/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import image from '@ohos.multimedia.image';
import fs from '@ohos.file.fs';
import fileuri from '@ohos.file.fileuri';
import { LogDomain, LogHelper, FileUtils } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { ThemeStyleInfo } from '../bean/ThemeStyleInfo';
import { EventConstants } from '../constants/EventConstants';

const TAG: string = 'ThemeStylePreviewManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 预览风格资源结构
 */
class PreviewThemeResource {
  background: string = '';
  foreground: string = '';
}

/**
 * 预览主题变变化回调结构
 */
export interface ThemePreviewCallback {
  onStyleChanged: (background: string, foreground: string) => void;
}

/**
 * 预览主题风格管理类
 */
export class ThemeStylePreviewManager {
  private static mInstance: ThemeStylePreviewManager;
  private iconBackgroundPath: string = '';
  private iconForegroundPath: string = '';
  private iconResourcesMap: Map<string, PreviewThemeResource> = new Map();
  private previewThemeCallbackMap: Map<string, ThemePreviewCallback> = new Map();
  private previewThemeStyle: ThemeStyleInfo = new ThemeStyleInfo();
  private previewThemeStyleChange: boolean = false;

  /**
   * 获取预览主题风格管理实例
   */
  static getInstance(): ThemeStylePreviewManager {
    if (!ThemeStylePreviewManager.mInstance) {
      ThemeStylePreviewManager.mInstance = new ThemeStylePreviewManager();
    }
    return ThemeStylePreviewManager.mInstance;
  }

  /**
   * 更新预览风格
   * @param themePath 预置主题路径
   * @param themeStyleInfo 主题风格信息，可选
   */
  public async updatePreviewStyle(themePath: string, themeStyleInfo?: ThemeStyleInfo): Promise<void> {
    if (FileUtils.isExist(themePath)) {
      await this.updatePreviewImageStyle(themePath);
    }

    if (themeStyleInfo) {
      this.updatePreviewStyleInfo(themeStyleInfo);
      this.previewThemeStyleChange = !this.previewThemeStyleChange;
      localEventManager.sendLocalEvent(EventConstants.EVENT_PREVIEW_STYLE_CHANGED, this.previewThemeStyleChange);
    }
  }

  /**
   * 获取主题风格信息
   *
   * @return ThemeStyleInfo 主题风格信息结构
   */
  public getThemeStyle(): ThemeStyleInfo {
    return this.previewThemeStyle;
  }

  /**
   * 获取风格资源前景图
   *
   * @param bundleName 包名
   * @return string 图片资源url
   */
  public getForegroundIcon(bundleName: string): string {
    if (!this.iconResourcesMap.has(bundleName)) {
      return '';
    }

    return this.iconResourcesMap.get(bundleName)?.foreground ?? '';
  }

  /**
   * 获取风格资源背景图
   *
   * @param bundleName 包名
   * @return string 图片资源url
   */
  public getBackgroundIcon(bundleName: string): string {
    if (!this.iconResourcesMap.has(bundleName)) {
      return '';
    }

    return this.iconResourcesMap.get(bundleName)?.background ?? '';
  }

  /**
   * 注册预置风格主题回调
   *
   * @param bundleName 包名
   * @param callback 回调函数，用于更新图标资源
   */
  public registerPreviewThemeCallback(bundleName: string, callback: ThemePreviewCallback): void {
    this.previewThemeCallbackMap.set(bundleName, callback);
  }

  /**
   * 去注册预置风格主题回调
   *
   * @param bundleName 包名
   */
  public unRegisterPreviewThemeCallback(bundleName: string): void {
    if (this.previewThemeCallbackMap.has(bundleName)) {
      this.previewThemeCallbackMap.delete(bundleName);
    }
  }

  /**
   * 更新预置风格资源
   *
   * @param themePath 预置主题路径
   */
  public async updatePreviewImageStyle(themePath: string): Promise<void> {
    if (!FileUtils.isExist(themePath)) {
      return;
    }
    if (!(await this.loadThemeResource(themePath))) {
      log.showError('load theme resource failed');
      return;
    }
    log.showInfo(`preview theme resources num: ${this.iconResourcesMap.size}`);

    this.previewThemeCallbackMap.forEach((value, key) => {
      value.onStyleChanged(this.getBackgroundIcon(key), this.getForegroundIcon(key));
    });
  }

  /**
   * 更新预置风格信息
   *
   * @param themeStyleInfo 主题风格信息
   */
  public updatePreviewStyleInfo(themeStyleInfo: ThemeStyleInfo): void {
    log.showInfo(`preview style iconSizeScale: ${themeStyleInfo.iconSizeScale} ` +
      `radiusSizeScale: ${themeStyleInfo.radiusSizeScale} isShowName: ${themeStyleInfo.isShowName}`);
    this.previewThemeStyle = themeStyleInfo;
  }

  /**
   * 清理预置管理类资源
   */
  public clearPreviewResources(): void {
    this.clearThemeResource();
    this.previewThemeStyle.iconSizeScale = undefined;
    this.previewThemeStyle.radiusSizeScale = undefined;
    this.previewThemeStyle.isShowName = true;
  }

  private async loadThemeResource(themePath: string): Promise<Boolean> {
    let fileList: string[] = [];
    try {
      fileList = await fs.listFileSync(themePath);
    } catch (e) {
      log.showError(`loadThemeResource fail: ${e?.code} ${e?.message}`);
      return false;
    }
    if (!fileList || fileList.length <= 0) {
      return false;
    }

    for (let i = 0; i < fileList.length; i++) {
      this.iconBackgroundPath = themePath + '/' + fileList[i] + '/entry/background.png';
      this.iconForegroundPath = themePath + '/' + fileList[i] + '/entry/foreground.png';
      let themeResources: PreviewThemeResource = new PreviewThemeResource();
      themeResources.background = fileuri.getUriFromPath(this.iconBackgroundPath);
      themeResources.foreground = fileuri.getUriFromPath(this.iconForegroundPath);
      this.iconResourcesMap.set(fileList[i], themeResources);
    }

    return true;
  }

  private clearThemeResource(): void {
    this.iconResourcesMap.clear();
  }
}