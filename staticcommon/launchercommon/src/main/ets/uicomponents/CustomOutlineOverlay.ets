/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants } from '../constants/CommonConstants';
import { StyleConstants } from '../constants/StyleConstants';

const TAG = 'CustomOutlineOverlay';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct CustomOutlineOverlay {
  private static readonly INVALID_POSITION = -100;
  private isShowOverlayBorder: boolean = false;
  @State @Watch('showStateChange') overLayShow: boolean = false;
  @State overLayAlpha: number = 0;
  @State folderPreviewScale: number = 1.0;
  @State folderPreviewAlpha: number = 0.5;
  @StorageLink('withBlur') withBlur: boolean = true;
  @StorageLink('showPressedFolderOverLay') showPressedFolderOverLay: boolean = false;
  @StorageLink('folderPreviewVisible') folderPreviewVisible: boolean = false;
  @StorageLink('overlayInsertPositionX') overlayInsertPositionX: number = 0;
  @StorageLink('overlayInsertPositionY') overlayInsertPositionY: number = 0;
  @StorageLink('overlayMode') @Watch('updateOverlayData') overlayMode: number = CommonConstants.OVERLAY_TYPE_HIDE;
  @StorageLink('showFolderPreViewOverLay') @Watch('updateFolderPreViewOverLay') showFolderPreViewOverLay: boolean = false;
  overlayData: ESObject = null;

  private updateOverlayData() {
    this.overlayData = AppStorage.get('overlayData');
    if (CheckEmptyUtils.isEmpty(this.overlayData)) {
      this.overLayShow = false;
      return;
    }
    if (this.overlayMode == CommonConstants.OVERLAY_TYPE_HIDE) {
      this.overLayShow = false;
    } else {
      this.overLayShow = true;
    }
  }

  private showStateChange() {
    const showCustomOutlineOverlay: boolean | undefined = AppStorage.get('showCustomOutlineOverlay');
    if (this.overLayShow) {
      if (showCustomOutlineOverlay) {
        if (AppStorage.get('device') != CommonConstants.DEFAULT_DEVICE_TYPE) {
          this.isShowOverlayBorder = true;
        } else {
          this.isShowOverlayBorder = false;
        }
        this.showOverLay();
      }
    } else {
      this.hideOverLay();
    }
  }

  private hideOverLay() {
    this.overlayMode = CommonConstants.OVERLAY_TYPE_HIDE;
    this.overLayAlpha = 0;
    this.overlayInsertPositionX = CustomOutlineOverlay.INVALID_POSITION;
    this.overlayInsertPositionY = CustomOutlineOverlay.INVALID_POSITION;
    this.withBlur = true;
  }

  private showOverLay() {
    animateTo({
      duration: 250,
      curve: Curve.Sharp
    }, () => {
      this.overLayAlpha = 1;
    })
  }

  private updateFolderPreViewOverLay() {
    if (this.showFolderPreViewOverLay) {
      this.folderPreviewVisible = true;
      log.showInfo('showFolderPreViewOverLay');
      animateTo({
        duration: 250,
        curve: Curve.Sharp
      }, () => {
        this.folderPreviewAlpha = 0.5;
        this.folderPreviewScale = 1.2;
      })
    } else {
      log.showInfo('hideFolderPreViewOverLay');
      animateTo({
        duration: 250,
        curve: Curve.Sharp,
        onFinish: () => {
          if (!this.overLayShow) {
            this.folderPreviewVisible = false;
          }
          log.showInfo('hideFolderPreViewOverLay finish');
        }
      }, () => {
        this.folderPreviewAlpha = 0;
        this.folderPreviewScale = 1.0;
      })
    }
  }

  build() {
    Stack() {
      if (this.withBlur) {
        Column()
          .blur(CommonConstants.OVERLAY_BLUR_RADIUS, undefined, { disableSystemAdaptation: true })
          .width('100%')
          .height('100%')
      }
      Column() {
        if (!CheckEmptyUtils.isEmpty(this.overlayData) && this.overlayMode == CommonConstants.OVERLAY_TYPE_APP_ICON) {
          Column() {
            if (AppStorage.get('overlayInsertItemType') == CommonConstants.TYPE_APP) {
              Image(null).draggable(false)
                .backgroundColor(Color.White)
                .borderRadius(16)
                .opacity(this.folderPreviewAlpha)
                .height(this.overlayData.iconSize / 1.1)
                .width(this.overlayData.iconSize / 1.1)
                .visibility(this.folderPreviewVisible ? Visibility.Visible : Visibility.Hidden)
                .scale({ x: this.folderPreviewScale, y: this.folderPreviewScale})
            } else if (this.isShowOverlayBorder) {
              Image(null).draggable(false)
                .border({
                  width: 1,
                  color: 0x7FFFFFFF,
                  radius: 16,
                  style: BorderStyle.Solid
                })
                .visibility(!this.showPressedFolderOverLay ? Visibility.Visible : Visibility.Hidden)
                .height(this.overlayData.iconSize / 1.1)
                .width(this.overlayData.iconSize / 1.1)
            }
          }
        } else if (!CheckEmptyUtils.isEmpty(this.overlayData) && this.overlayMode ==
          CommonConstants.OVERLAY_TYPE_FOLDER && this.isShowOverlayBorder) {
          Image(null).draggable(false)
            .height(this.overlayData.folderGridSize / 1.1)
            .width(this.overlayData.folderGridSize / 1.1)
            .border({
              width: 1,
              color: 0x7FFFFFFF,
              radius: 24,
              style: BorderStyle.Solid
            })
        } else if (!CheckEmptyUtils.isEmpty(this.overlayData) && this.overlayMode ==
          CommonConstants.OVERLAY_TYPE_CARD && this.isShowOverlayBorder) {
          Image(null).draggable(false)
            .height(this.overlayData.formHeight / 1.1)
            .width(this.overlayData.formWidth / 1.1)
            .border({
              width: 1,
              color: 0x7FFFFFFF,
              radius: 24,
              style: BorderStyle.Solid
            })
        }
      }
      .position({
        x: this.overlayInsertPositionX,
        y: this.overlayInsertPositionY,
      })
    }
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .visibility(this.overLayShow ? Visibility.Visible : Visibility.None)
    .opacity(this.overLayAlpha)
  }
}