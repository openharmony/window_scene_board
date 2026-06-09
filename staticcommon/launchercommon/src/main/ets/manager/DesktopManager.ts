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

import type common from '@ohos.app.ability.common';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext, sSettingsUtil, WallpaperColorManager } from '@ohos/frameworkwrapper';
import { DesktopParam } from '../bean/DesktopParam';
import { image } from '@kit.ImageKit';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { DisplayConstants } from '@ohos/windowscene/src/main/ets/TsIndex';
import { i18n } from '@kit.LocalizationKit';
import contextConstant from '@ohos.app.ability.contextConstant';

const TAG = 'DesktopManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const README_TXT = 'this directory is use desktop preview!';
const DESKTOP_PREVIEW_DIR = 'desktopPreview';

/**
 * 桌面参数管理类
 */
export class DesktopManager {
  private static instance: DesktopManager;
  private desktopParam: DesktopParam;
  private initMethod?: () => void;

  private screenChangeCallback: Set<() => void> = new Set<() => void>();

  constructor() {
    this.desktopParam = new DesktopParam();
  }

  public static getInstance(): DesktopManager {
    if (!DesktopManager.instance) {
      DesktopManager.instance = new DesktopManager();
    }
    return DesktopManager.instance;
  }

  public registerInitCallback(cb: () => void): void {
    this.initMethod = cb;
  }

  public unregisterInitCallback(): void {
    this.initMethod = undefined;
  }

  /**
   * 注册屏幕变化回调监听
   *
   * @param listener
   */
  public registerScreenChangeListener(listener: () => void): void {
    if (listener) {
      this.screenChangeCallback.add(listener);
    }
  }

  /**
   * 取消注册屏幕变化回调监听
   *
   * @param listener
   */
  public unregisterScreenChangeListener(listener: () => void): void {
    if (listener) {
      this.screenChangeCallback.delete(listener);
    }
  }

  /**
   * 执行屏幕变化回调
   */
  public execScreenChangeListener(): void {
    this.screenChangeCallback?.forEach((listener: () => void) => {
      listener?.();
    });
  }

  public getDesktopParam(): DesktopParam {
    return this.desktopParam;
  }

  public updateParam(): DesktopManager {
    this.initMethod?.();
    this.desktopParam.isShowName = sSettingsUtil.getSecureValue('isDesktopIconShowName') !== 'false';
    this.desktopParam.itemPadding = AppStorage.get<number>('itemPadding');
    this.desktopParam.nameFontColor = WallpaperColorManager.getInstance()?.mTextColor?.mTextColor;
    this.desktopParam.isRTL = i18n.isRTL(i18n.System.getSystemLanguage());
    return this;
  }

  public updateExtendParam(): DesktopManager {
    const defaultDpi = parseInt(sSettingsUtil.getValue('system_default_dpi_value', '')) /
    DisplayConstants.DEFAULT_DPI_DENSITY;
    this.desktopParam.vp2pxScale = isNaN(Number(defaultDpi)) ? vp2px(1) : defaultDpi; // vp转px系数

    let iconChangeSizeStr: string = sSettingsUtil.getSecureValue('desktopIconChangeSize');
    let iconChangeSize: number = Number(iconChangeSizeStr);
    this.desktopParam.iconChangeSize = iconChangeSize;
    return this;
  }

  /**
   * 获取EL1加密区files文件夹路径
   *
   * @param context 上下文对象
   * @returns el1 files路径
   * @throws { Error } - null context error
   */
  private getEL1FilesDir(context: common.Context): string {
    if (!context) {
      throw new Error('context is null');
    }
    let filesDir = context.filesDir;
    if (context.area === contextConstant.AreaMode.EL2) {
      context.area = contextConstant.AreaMode.EL1;
      filesDir = context.filesDir;
      context.area = contextConstant.AreaMode.EL2;
    }
    return filesDir;
  }

  /**
   * 把DesktopParam保存在路径desktopPreview中
   */
  public saveDesktopParam(): void {
    try {
      // 由于壁纸指定从el1区读取DesktopParam参数，无论当前处于哪个区，写DesktopParam参数时指定写进el1区
      let filesDir: string = this.getEL1FilesDir(GlobalContext.getContext());
      let filePath = `${filesDir}/desktopPreview/desktopParam.json`;
      let previewPath = `${filesDir}/${DESKTOP_PREVIEW_DIR}`;
      this.createReadMe(previewPath);
      let file = fileIo.openSync(filePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      let updataDesktopParam: DesktopParam = this.updateParam().updateExtendParam().getDesktopParam();
      fileIo.writeSync(file.fd, JSON.stringify(updataDesktopParam));
      log.showInfo('saveDesktopParam file[%{public}s].', JSON.stringify(updataDesktopParam));
      fileIo.closeSync(file);
    } catch (error) {
      log.showError(`saveDesktopParam error: ${error}`);
    }
  }

  /**
   * 把图片保存到本地
   * @param pixmap
   * @param componentId
   */
  public async savePixmap2file(pixmap: image.PixelMap, componentId: string): Promise<void> {
    let filesDir: string = GlobalContext.getContext().filesDir;
    let previewPath = `${filesDir}/${DESKTOP_PREVIEW_DIR}`;
    this.createReadMe(previewPath);
    let fileName: string = `${previewPath}/${componentId}.png`;
    let file: fileIo.File | undefined;
    try {
      file = fileIo.openSync(fileName, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      log.showError(`openSync file.code ${error.code},message is ${error.message}`);
    }
    if (!file) {
      log.showError(`open file error.`);
      return;
    }
    let imagePackerApi: image.ImagePacker | undefined = undefined;
    try {
      let packOpts: image.PackingOption = { format: 'image/png', quality: 98 };
      imagePackerApi = image.createImagePacker();
      await imagePackerApi.packToFile(pixmap, file.fd, packOpts).then(() => {
        log.showInfo('create file[%{public}s].', fileName);
      }).catch((error: BusinessError) => {
        log.showError(`savePixmap2file. fileName: ${fileName}, file.fd: ${file?.fd}, code ${error.code},message: ${error.message}`);
      });
    } catch (error) {
      log.showError(`savePixmap2file error: ${error}`);
    } finally {
      imagePackerApi?.release();
    }
    if (file) {
      fileIo.closeSync(file);
    }
  }

  private createReadMe(previewPath: string): void {
    try {
      let readmePath = `${previewPath}/readme.txt`;
      if (!fileIo.accessSync(readmePath)) {
        fileIo.mkdirSync(previewPath);
        this.createReadMeFile(readmePath);
      }
    } catch (error) {
      log.showError(`Failed to createReadMe, error: ${error}`);
    }
  }

  private createReadMeFile(readmePath: string): void {
    let file: fileIo.File | undefined;
    try {
      file = fileIo.openSync(readmePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      fileIo.writeSync(file.fd, README_TXT);
      log.showInfo('create readme');
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      log.showError(`createReadMeFile error file.code ${error.code},message is ${error.message}`);
    } finally {
      if (file) {
        fileIo.closeSync(file);
      }
    }
  }
}