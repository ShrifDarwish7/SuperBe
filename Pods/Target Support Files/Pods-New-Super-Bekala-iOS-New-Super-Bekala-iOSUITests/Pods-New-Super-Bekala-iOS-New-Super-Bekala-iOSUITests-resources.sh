#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR

if [ -z ${UNLOCALIZED_RESOURCES_FOLDER_PATH+x} ]; then
  # If UNLOCALIZED_RESOURCES_FOLDER_PATH is not set, then there's nowhere for us to copy
  # resources to, so exit 0 (signalling the script phase was successful).
  exit 0
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")

case "${TARGETED_DEVICE_FAMILY:-}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  4)
    TARGET_DEVICE_ARGS="--target-device watch"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\"" || true
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH" || true
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/am.imageset/am.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/am.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card.imageset/card.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card.imageset/card@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card.imageset/card@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card_icon.imageset/card_icon.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card_icon.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/close.imageset/close.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/close.imageset/close@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/close.imageset/close@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/close.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/cvc_icon.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/cvc_icon.imageset/cvc_icon.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/cvc_icon.imageset/cvc_icon@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/cvc_icon.imageset/cvc_icon@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/date_icon.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/date_icon.imageset/date_icon.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/date_icon.imageset/date_icon@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/date_icon.imageset/date_icon@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/dc.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/dc.imageset/dc.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/ds.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/ds.imageset/ds.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/ic_wallet_sdk.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/ic_wallet_sdk.imageset/ic_wallet_sdk.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/jcb.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/jcb.imageset/jcb.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/LaunchImage.launchimage/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/Maestro.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/Maestro.imageset/Maestro.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/mc.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/mc.imageset/mc.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/Mir.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/Mir.imageset/Mir.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/miza_logo.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/miza_logo.imageset/miza_logo.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/miza_logo.imageset/miza_logo@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/miza_logo.imageset/miza_logo@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/power_by_paysky.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/power_by_paysky.imageset/power_by_paysky.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/power_by_paysky.imageset/power_by_paysky@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/power_by_paysky.imageset/power_by_paysky@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/scan_card.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/scan_card.imageset/scan_card.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/scan_card.imageset/scan_card@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/scan_card.imageset/scan_card@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/selected_wallet.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/selected_wallet.imageset/selected_wallet.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/selected_wallet.imageset/selected_wallet@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/selected_wallet.imageset/selected_wallet@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/three_dots.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/three_dots.imageset/three_dots.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/three_dots.imageset/three_dots@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/three_dots.imageset/three_dots@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionApproved.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionApproved.imageset/TransactionApproved.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionApproved.imageset/TransactionApproved@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionApproved.imageset/TransactionApproved@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionDeclined.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionDeclined.imageset/TransactionDeclined.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionDeclined.imageset/TransactionDeclined@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionDeclined.imageset/TransactionDeclined@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/UnionPay.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/UnionPay.imageset/UnionPay.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/un_selected_card.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/un_selected_card.imageset/un_selected_card.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/un_selected_card.imageset/un_selected_card@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/un_selected_card.imageset/un_selected_card@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/upg_orange_logo.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/upg_orange_logo.imageset/upg_orange_logo.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/vi.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/vi.imageset/vi.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/wallet.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/wallet.imageset/wallet.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/wallet.imageset/wallet@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/wallet.imageset/wallet@3x.png"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/AlertDialogViewController.nib"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/RequestMoneyViewController.nib"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/CardTableViewCell.nib"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/CompleteTableViewCell.nib"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/PayButtonBoard.storyboardc"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/QRTableViewCell.nib"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/WebViewTableViewCell.nib"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Strings/ar.lproj/LocalizablePaySKy.strings"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Strings/en.lproj/LocalizablePaySKy.strings"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Strings/ar.lproj"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Strings/en.lproj"
  install_resource "${PODS_ROOT}/PayButton/PayButton/TestApi/Base.lproj"
  install_resource "${PODS_CONFIGURATION_BUILD_DIR}/PayButton/PayButton.bundle"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/am.imageset/am.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/am.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card.imageset/card.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card.imageset/card@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card.imageset/card@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card_icon.imageset/card_icon.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/card_icon.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/close.imageset/close.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/close.imageset/close@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/close.imageset/close@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/close.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/cvc_icon.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/cvc_icon.imageset/cvc_icon.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/cvc_icon.imageset/cvc_icon@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/cvc_icon.imageset/cvc_icon@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/date_icon.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/date_icon.imageset/date_icon.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/date_icon.imageset/date_icon@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/date_icon.imageset/date_icon@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/dc.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/dc.imageset/dc.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/ds.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/ds.imageset/ds.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/ic_wallet_sdk.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/ic_wallet_sdk.imageset/ic_wallet_sdk.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/jcb.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/jcb.imageset/jcb.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/LaunchImage.launchimage/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/Maestro.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/Maestro.imageset/Maestro.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/mc.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/mc.imageset/mc.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/Mir.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/Mir.imageset/Mir.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/miza_logo.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/miza_logo.imageset/miza_logo.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/miza_logo.imageset/miza_logo@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/miza_logo.imageset/miza_logo@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/power_by_paysky.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/power_by_paysky.imageset/power_by_paysky.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/power_by_paysky.imageset/power_by_paysky@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/power_by_paysky.imageset/power_by_paysky@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/scan_card.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/scan_card.imageset/scan_card.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/scan_card.imageset/scan_card@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/scan_card.imageset/scan_card@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/selected_wallet.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/selected_wallet.imageset/selected_wallet.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/selected_wallet.imageset/selected_wallet@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/selected_wallet.imageset/selected_wallet@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/three_dots.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/three_dots.imageset/three_dots.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/three_dots.imageset/three_dots@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/three_dots.imageset/three_dots@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionApproved.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionApproved.imageset/TransactionApproved.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionApproved.imageset/TransactionApproved@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionApproved.imageset/TransactionApproved@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionDeclined.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionDeclined.imageset/TransactionDeclined.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionDeclined.imageset/TransactionDeclined@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/TransactionDeclined.imageset/TransactionDeclined@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/UnionPay.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/UnionPay.imageset/UnionPay.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/un_selected_card.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/un_selected_card.imageset/un_selected_card.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/un_selected_card.imageset/un_selected_card@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/un_selected_card.imageset/un_selected_card@3x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/upg_orange_logo.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/upg_orange_logo.imageset/upg_orange_logo.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/vi.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/vi.imageset/vi.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/wallet.imageset/Contents.json"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/wallet.imageset/wallet.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/wallet.imageset/wallet@2x.png"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets/wallet.imageset/wallet@3x.png"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/AlertDialogViewController.nib"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/RequestMoneyViewController.nib"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/CardTableViewCell.nib"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/CompleteTableViewCell.nib"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/PayButtonBoard.storyboardc"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/QRTableViewCell.nib"
  install_resource "${BUILT_PRODUCTS_DIR}/PayButton/PayButton.framework/WebViewTableViewCell.nib"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Strings/ar.lproj/LocalizablePaySKy.strings"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Strings/en.lproj/LocalizablePaySKy.strings"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Assets.xcassets"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Strings/ar.lproj"
  install_resource "${PODS_ROOT}/PayButton/PayButton/Strings/en.lproj"
  install_resource "${PODS_ROOT}/PayButton/PayButton/TestApi/Base.lproj"
  install_resource "${PODS_CONFIGURATION_BUILD_DIR}/PayButton/PayButton.bundle"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "${XCASSET_FILES:-}" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find -L "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  if [ -z ${ASSETCATALOG_COMPILER_APPICON_NAME+x} ]; then
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  else
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${TARGET_TEMP_DIR}/assetcatalog_generated_info_cocoapods.plist"
  fi
fi
