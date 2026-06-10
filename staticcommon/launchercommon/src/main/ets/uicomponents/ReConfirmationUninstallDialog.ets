/*
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

import { CustomContentDialog } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import type ctx from '@ohos.app.ability.common';
import { GlobalContext, IconResourceManager, onLineThemeUtil } from '@ohos/frameworkwrapper';
import { CommonConstants } from '../constants/CommonConstants';
import { StyleConstants } from '../constants/StyleConstants';
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';

const TAG = 'ReConfirmationUninstallDialog';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const APP_CLONE_BADGE_SIZE = 21;

@CustomDialog
export struct ReConfirmationUninstallDialog {
  @StorageLink('showUninstallDialog') @Watch('showUninstallDialogChange') showUninstallDialog: boolean = false;
  private controller?: CustomDialogController;
  private cancel?: Function;
  private confirm?: Function;
  private icon: image.PixelMap | ResourceStr | undefined = undefined;
  private mImageSize: number = 0;
  private title: string | Resource = '';
  private content: string | Resource = '';
  private appIndex: number = 0;
  private bundleName: string = '';
  private moduleName: string = '';
  private abilityName: string = '';

  public aboutToAppear(): void {
    log.showInfo(TAG, 'ReConfirmationUninstallDialog dialog aboutToAppear.');
    this.mImageSize = StyleConstants.DEFAULT_APP_ITEM_HEIGHT + StyleConstants.DEFAULT_2;
    this.title = $r('app.string.remove_wechat_reConfirm_title');
    this.content = $r('app.string.remove_wechat_reConfirm_content');
    if (CheckEmptyUtils.isEmpty(this.icon)) {
      this.updateIcon();
    }
  }

  /**
   * 图标资源优先从内存缓存读取，读不到再从三级缓存获取
   */
  private updateIcon(): void {
    this.icon = IconResourceManager.getInstance().getCachedCombIconSync(this.bundleName,
      this.moduleName, this.abilityName, this.appIndex);
    if (!CheckEmptyUtils.isEmpty(this.icon)) {
      log.showInfo(TAG, 'updateIcon done.');
      return;
    }

    this.updateIconAsync();
  }

  private async updateIconAsync() {
    try {
      let iconResource = await IconResourceManager.getInstance().getCombIcon(this.bundleName,
        this.moduleName, this.abilityName, this.appIndex, 'CombIcon_UninstallDialog');
      this.icon = CheckEmptyUtils.isEmpty(iconResource) ? '' : iconResource;
      log.showInfo(TAG, 'updateIconAsync icon done.');
    } catch (error) {
      log.error('initDialogIcon', error);
    }
  }

  private showUninstallDialogChange() {
    log.showInfo(TAG, `UninstallDialog showUninstallDialogChange showUninstallDialog: ${this.showUninstallDialog}`);
    if (!this.showUninstallDialog) {
      this.controller?.close();
      this.cancel?.()
    }
  }

  build() {
    CustomContentDialog({
      contentBuilder: () => {
        this.dialogContentBuilder();
      },
      buttons: [
        {
          value: $r('app.string.cancel'),
          action: () => {
            this.controller?.close();
            this.cancel?.();
          }
        },
        {
          value: $r('app.string.reConfirm_remove'),
          fontColor: $r('sys.color.ohos_id_color_warning'),
          action: () => {
            this.controller?.close();
            (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub
              .emit(`appUninstall${this.bundleName}`);
            this.confirm?.();
          }
        }
      ]
    })
  }

  @Builder
  dialogContentBuilder() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Image(this.icon)
          .width(this.mImageSize)
          .height(this.mImageSize)
          .draggable(false)
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
          .clip(true)
          .enabled(false)
          .borderRadius(onLineThemeUtil.isOnlineTheme() ? 0 : CommonConstants.DEFAULT_ICON_RADIUS)
        if (this.appIndex > 0) {
          Image($r(`app.media.app_icon_clone_index_${this.appIndex}`))
            .height(APP_CLONE_BADGE_SIZE)
            .width(APP_CLONE_BADGE_SIZE)
            .enabled(false)
            .offset({
              x: RTLUtil.isRTL() ? StyleConstants.DEFAULT_4 - this.mImageSize / 2 :
                this.mImageSize / 2 - StyleConstants.DEFAULT_4,
              y: this.mImageSize / 2 - StyleConstants.DEFAULT_8
            })
        }
      }
      Text(this.title)
        .margin({
          top: StyleConstants.DEFAULT_16,
          bottom: StyleConstants.DEFAULT_16,
        })
        .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
        .maxFontScale(CommonConstants.AGING_FONT_SCALE)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
      Text(this.content)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .maxFontScale(CommonConstants.AGING_FONT_SCALE)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_primary'))
    }
    .width('100%')
  }
}