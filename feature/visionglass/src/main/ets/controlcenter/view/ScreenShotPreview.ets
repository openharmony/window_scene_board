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

import { GlassSceneManager } from '../../scene/common/GlassSceneManager';
import ScreenShotManager from '../manager/ScreenshotManager';
import Constants from '../components/constants/Constants';
import { Want } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassAppWhiteListManager } from '../../common/manager/GlassAppWhiteListManager';
import { GlassShowToastOptions, GlassToastManager } from '../../toast/manager/GlassToastManager';
import { GlassAppWhiteListToastCommon } from '../../common/constants/GlassLayoutConstants';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';

const photoBundleName = 'com.ohos.photos';
const photoAbilityName = 'com.ohos.photos.MainAbility';
const photoModuleName = 'phone_photos';

const TAG = 'ScreenShotPreview';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct ScreenShotPreview {
  @StorageLink('captureImage') captureImage: string = '';
  @StorageLink('imageFilename') imageFileName: string = photoModuleName;

  /**
   * 如果当前活动的包名与照片包名不匹配，则显示相册场景。
   * 使用 `startSceneFromIcon` 方法通过 GlassSceneManager 启动场景。
   *
   * @returns {void}
   */
  private showAlbum(): void {
    // 定义将要使用的 want 数据对象，以启动场景。
    // 这个对象包括了包名、能力名以及用于指定图片文件名的参数（uri）。
    if (!GlassAppWhiteListManager.getInstance().isWhiteListApp(photoBundleName)) {
      let appName: string = GlassAppWhiteListManager.getInstance().getAppName(photoBundleName);
      log.showInfo(`showAlbum cancel,photo app is not in vision glass`);
      let options: GlassShowToastOptions = {
        message: GlassAppWhiteListToastCommon.getAddMsg(appName),
        bottom: GlassAppWhiteListToastCommon.TOAST_BOTTOM,
        duration: GlassAppWhiteListToastCommon.TOAST_DURATION,
        width: GlassAppWhiteListToastCommon.ADD_APP_TO_GLASS_WID
      }
      GlassToastManager.getInstance().showToast(options);
      return;
    }
    const wantData: Want = {
      bundleName: photoBundleName,
      abilityName: photoAbilityName,
      parameters: {
        uri: this.imageFileName
      }
    };

    // 检查当前活动的包名是否与照片包名不匹配。
    // 如果这个条件为真，那么意味着我们需要显示相册场景。
    // 主要为了避免当已经在照片应用的时候重复拉起应用的场景（会出现应用布局错乱）。
    if (photoBundleName !== GlassSceneManager.getInstance().getActiveWant()?.bundleName) {
      // 使用 want 数据从图标启动相册场景。
      GlassSceneManager.getInstance().startSceneFromIcon(wantData);
    }
  }

  onClose() {
    GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_SCREENSHOT_PREVIEW);
    ScreenShotManager.getInstance().release();
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Image(this.captureImage)
        .borderRadius(Constants.IMAGE_BORDER_RADIUS)
        .width(Constants.FULL_IMAGE_WIDTH)
        .height(Constants.FULL_IMAGE_HEIGHT)
        .align(Alignment.Center)
        .border({
          color: Color.White,
          width: '10px',
          radius: '8px'
        });
    }
    .width(Constants.FULL_CONTAINER_WIDTH)
    .height(Constants.FULL_CONTAINER_HEIGHT)
    .borderRadius(Constants.IMAGE_BORDER_RADIUS)
    .onClick(() => {
      this.onClose();
      this.showAlbum();
    });
  }
}