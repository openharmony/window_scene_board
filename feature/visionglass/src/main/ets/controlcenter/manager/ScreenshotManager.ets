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

import { screenshot } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { userFileManager } from '@kit.CoreFileKit';
import { GlassSceneManager, Rect } from '../../scene/common/GlassSceneManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { VisionGlassResourceManager } from '../../IdlVisionGlassExtService/VisionGlassResourceManager';
import { bundleManager, Permissions } from '@kit.AbilityKit';
import { abilityAccessCtrl } from '@kit.AbilityKit'
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'ScreenShotManager');

/**
 * 截图管理类
 */
export default class ScreenShotManager {
  public static readonly VISION_GLASS_BUNDLE_NAME: string = 'com.ohos.visionglass';
  public static readonly DEFAULT_BUNDLE_INFO_FLAG: number = 0x00000000;
  public static readonly SAVE_IMAGE_RIGHT_NAME: Permissions = 'ohos.permission.WRITE_IMAGEVIDEO';
  public static readonly NO_PERMISSION_GRANTED_MSG: ResourceStr = $r('app.string.control_screenshot_no_right');
  public static readonly PRIVACY_SCREEN: ResourceStr = $r('app.string.screenshot_privacy');
  public static readonly PERMISSION_GRANTED_CODE: number = 0;
  private pixelMap?: image.PixelMap;
  private static instance?: ScreenShotManager;
  private isPreviewVisible: boolean = false;
  private screenShotPreviewDisappearTimer?: number;
  private takeScreenShotTimer?: number;
  private generateScreenShotPreviewTimer?: number;
  private takeScreenShotInterval: number = 100;
  private generateScreenShotPreviewInterval: number = 300;
  private screenShotPreviewDisappearInterval: number = 5400;

  private constructor() {
  }

  /*
   * 获取当前控制中心截图预览可见状态
   *
   * @return boolean
   * */
  public getIsPreviewVisibile(): boolean {
    return this.isPreviewVisible;
  }

  /*
   * 设置控制中心截图预览可见状态
   *
   * @param isPreviewVisible
   * */
  public setIsPreviewVisibile(isPreviewVisible: boolean): void {
    this.isPreviewVisible = isPreviewVisible;
  }

  /*
   * 获取控制中心截图截图管理类单例
   *
   * @return ScreenShotManager
   * */
  public static getInstance(): ScreenShotManager {
    if (!ScreenShotManager.instance) {
      ScreenShotManager.instance = new ScreenShotManager();
    }
    return ScreenShotManager.instance;
  }

  /*
   * 销毁当前单例
   * */
  public static destroy(): void {
    ScreenShotManager.instance = undefined;
  }

  /*
   *  重置截图延迟计时器
   * */
  public resetScreenShotTimer(): void {
    if (this.screenShotPreviewDisappearTimer) {
      clearTimeout(this.screenShotPreviewDisappearTimer);
      this.screenShotPreviewDisappearTimer = undefined;
    }
    if (this.takeScreenShotTimer) {
      clearTimeout(this.takeScreenShotTimer);
      this.screenShotPreviewDisappearTimer = undefined;
    }
    if (this.generateScreenShotPreviewTimer) {
      clearTimeout(this.generateScreenShotPreviewTimer);
      this.screenShotPreviewDisappearTimer = undefined;
    }
  }

  /*
   * 更新截图坐标
   *
   * @param rect
   * */
  public updateScreenShotPreviewPosition(rect: Rect): void {
    GlassSystemSceneManager.getInstance().updateWindowRect(GlassSystemSceneType.GLASS_SCREENSHOT_PREVIEW, rect);
  }

  /*
   * 检查当前截图是否展示并更新状态
   * */
  public checkScreenShotPreviewOnShow(): void {
    if (GlassSystemSceneManager.getInstance().isSystemViewShow(GlassSystemSceneType.GLASS_SCREENSHOT_PREVIEW)) {
      GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_SCREENSHOT_PREVIEW);
    }
    this.isPreviewVisible = false;
  }

  /*
   * 执行截图
   * */
  public async takeScreenShot(): Promise<void> {
    this.takeScreenShotTimer = setTimeout(async () => {
      await VisionGlassResourceManager.getInstance().changePointerVisible(false)
      ScreenShotManager.getInstance().shotScreen({
        displayId: GlassSceneManager.getInstance().getScreenId()
      });
      VisionGlassResourceManager.getInstance().changePointerVisible(true)
    }, this.takeScreenShotInterval);
  }

  /*
   * 设置截图延迟出现
   * */
  public generateScreenShotPreview(): void {
    this.generateScreenShotPreviewTimer = setTimeout(() => {
      GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_SCREENSHOT_PREVIEW);
      this.isPreviewVisible = true;
    }, this.generateScreenShotPreviewInterval);
  }

  /*
   * 设置截图延迟消失
   * */
  public waitScreenShotPreviewDisappear(): void {
    this.screenShotPreviewDisappearTimer = setTimeout(() => {
      GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_SCREENSHOT_PREVIEW);
      this.isPreviewVisible = false;
    }, this.screenShotPreviewDisappearInterval);
  }

  /*
   * 截取当前屏幕
   *
   * @param options
   * */
  public async shotScreen(options?: screenshot.ScreenshotOptions): Promise<void> {
    log.info(`changePointerVisible shotScreen`);
    if (!options) {
      log.showInfo(`shotScreen fail,options is invalid`);
      return;
    }
    try {
      const data = await screenshot.save(options);
      this.pixelMap = data;
      AppStorage.set('captureImage', this.pixelMap);
      await this.saveImage(data, {
        format: 'image/jpeg',
        quality: 100,
      });
    } catch (exception) {
      log.error('Failed to save screenshot.');
    }
  }

  /*
   * 销毁当前截图
   * */
  public release(): void {
    this.pixelMap?.release();
  }

  /*
   * 获取用户文件管理器
   *
   * @param userFileManager.UserFileManager
   * */
  public getUserFileManager(): userFileManager.UserFileManager {
    return userFileManager.getUserFileMgr(GlobalContext.getContext());
  }

  private generateImageFileName(): string {
    return `Screenshot_${(new Date()).getTime()}.jpg`;
  }

  private async packImage(pixelMap: image.PixelMap, options: image.PackingOption): Promise<ArrayBuffer> {
    const packer = image.createImagePacker();
    return await packer.packing(pixelMap, options);
  }

  private async saveImage(pixelMap: image.PixelMap, options: image.PackingOption): Promise<void> {
    const imageFileName = this.generateImageFileName();
    const packedImg = await this.packImage(pixelMap, options);
    await VisionGlassResourceManager.getInstance().saveImage(imageFileName, packedImg);
  }

  /*
   * 按顺序执行截图全流程操作
   *
   * @param rect
   * */
  public async showWindow(rect: Rect): Promise<void> {
    this.resetScreenShotTimer();
    this.checkScreenShotPreviewOnShow();
    this.updateScreenShotPreviewPosition(rect);
    await this.takeScreenShot();
    this.generateScreenShotPreview();
    this.waitScreenShotPreviewDisappear();
  }

  /*
  * 检查vision glass是否有权限存储截图到图库
  *
  * @return boolean
  * */
  public async checkIsGlassCanSaveImage(): Promise<boolean> {
    let isGlassCanSaveImage: boolean = false;
    let info: bundleManager.ApplicationInfo =
      await bundleManager.getApplicationInfo(ScreenShotManager.VISION_GLASS_BUNDLE_NAME,
        ScreenShotManager.DEFAULT_BUNDLE_INFO_FLAG)
    if (!info) {
      log.showInfo(`checkIsGlassCanSaveImage cancel,not find current appInfo`);
      return isGlassCanSaveImage;
    }
    try {
      isGlassCanSaveImage = abilityAccessCtrl.createAtManager()
        .checkAccessTokenSync(info.accessTokenId, ScreenShotManager.SAVE_IMAGE_RIGHT_NAME) ===
      ScreenShotManager.PERMISSION_GRANTED_CODE
    } catch (err) {
      log.showInfo(`checkIsGlassCanSaveImage fail ,error code is ${err.code}`);
    }
    return isGlassCanSaveImage;
  }
}