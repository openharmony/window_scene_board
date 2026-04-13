/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import type { ILiveExtendData } from '@ohos/systemuicommon';
import { ArrayUtils, CommonUtils } from '@ohos/basicutils';
import type { IUpdatable } from '@ohos/systemuicommon';
import type { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import type image from '@ohos.multimedia.image';
import { appIconHelper } from '../../common/helper/ImmersiveAppIconHelper';
import { appNameHelper } from '../../common/helper/ImmersiveAppNameHelper';

/**
 * 沉浸式锁屏胶囊数据模型
 */
@Observed
export class ImmersiveNormalCapsuleData implements IUpdatable {
  /**
   * 通知唯一标识
   */
  private hashCode?: string;

  /**
   * 胶囊图标
   */
  private ntfAppIcon?: image.PixelMap | string | DrawableDescriptor;

  /**
   * 通知小图标
   */
  private overlayIcon?: image.PixelMap;

  /**
   * 胶囊主文本
   */
  private mainText?: string = '';

  /**
   * 胶囊副文本
   */
  private assistantText?: string = '';

  /**
   * 用于扩展胶囊辅助区内容
   * 按钮等
   */
  public auxiliaryData?: ILiveExtendData;

  /**
   * 应用名称
   */
  private appName?: string;

  /**
   * 否隐藏通知内容
   */
  private isNtfHideContent: boolean = false;

  /**
   * 组通知中的子通知集
   * 组通知时赋值
   */
  public childrenData: ImmersiveNormalCapsuleData[] = [];

  /**
   * 创建组通知
   */
  createGroup(): void {
    this.deleteGroup();
    this.childrenData.push(this);
  }

  /**
   * 添加子通知数据到分组
   *
   * @param newData 子通知
   */
  addChildData(newData: ImmersiveNormalCapsuleData): void {
    this.childrenData.push(newData);
  }

  /**
   * 删除分组数据
   */
  deleteGroup(): void {
    ArrayUtils.clearArr(this.childrenData);
  }

  /**
   * 设置通知是否隐藏
   *
   * @param isHideContent 是否隐藏
   */
  setNtfHide(isHideContent: boolean): void {
    this.isNtfHideContent = isHideContent;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof ImmersiveNormalCapsuleData)) {
      return;
    }
    let otherCapsule = other as ImmersiveNormalCapsuleData;

    this.setHashCode(otherCapsule.hashCode);
    this.setIcon(otherCapsule.ntfAppIcon);
    this.setOverlayIcon(otherCapsule.overlayIcon);
    this.setMainText(otherCapsule.mainText);
    this.setAssistantText(otherCapsule.assistantText);

    // 扩展数据，强制更新或未设置或扩展数据类型切换，则直接设置
    if (forceRefresh || CommonUtils.isInvalid(this.auxiliaryData)) {
      this.setAuxiliaryData(otherCapsule.auxiliaryData, forceRefresh);
    } else {
      this.auxiliaryData?.update(otherCapsule.auxiliaryData, forceRefresh);
    }
  }

  /**
   * 设置通知唯一标识
   *
   * @param hashCode 唯一标识
   * @param forceRefresh 是否强制刷新
   */
  setHashCode(hashCode?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(hashCode)) {
      this.hashCode = hashCode;
    }
  }

  /**
   * 设置胶囊图标
   *
   * @param icon 胶囊图标
   * @param forceRefresh 是否强制刷新
   */
  setIcon(icon?: image.PixelMap | string | DrawableDescriptor, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(icon)) {
      this.ntfAppIcon = icon;
    }
  }

  /**
   * 设置通知小图标
   *
   * @param smallIcon 通知小图标
   * @param forceRefresh 是否强制刷新
   */
  setOverlayIcon(overlayIcon?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(overlayIcon)) {
      this.overlayIcon = overlayIcon;
    }
  }

  /**
   * 设置胶囊主文本
   *
   * @param mainText 主文本
   * @param forceRefresh 是否强制刷新
   */
  setMainText(mainText?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(mainText)) {
      this.mainText = mainText;
    }
  }

  /**
   * 设置胶囊副文本
   *
   * @param secondText 副文本
   * @param forceRefresh 是否强制刷新
   */
  setAssistantText(secondText?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(secondText)) {
      this.assistantText = secondText;
    }
  }

  /**
   * 设置胶囊扩展数据
   *
   * @param extendData 扩展数据
   * @param forceRefresh 是否强制刷新
   */
  setAuxiliaryData(extendData?: ILiveExtendData, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(extendData)) {
      this.auxiliaryData = extendData;
    }
  }

  /**
   * 获取沉浸锁屏胶囊需要显示的应用图标
   *
   * @returns 图片
   */
  getAppIcon(): image.PixelMap | string | DrawableDescriptor | undefined {
    this.ntfAppIcon = appIconHelper.getAppIcon(this.hashCode);
    return this.ntfAppIcon;
  }

  /**
   * 获取沉浸锁屏胶囊需要显示的应用名
   *
   * @returns 图片
   */
  getAppName(): string | undefined {
    this.appName = appNameHelper.getAppName(this.hashCode);
    return this.appName;
  }

  toString(): string {
    let string = `hashCode: ${this.hashCode}, appName: ${this.appName}, idHide: ${this.isNtfHideContent}, child:`;
    this.childrenData.forEach(data => {
      string += `main: ${data?.mainText}, assistantText: ${data?.assistantText} `;
    });
    return string;
  }

  /**
   * 应用图标数据变化回调
   */
  onAppIconChange(): void {
    this.ntfAppIcon = appIconHelper.getAppIcon(this.hashCode);
  }

  /**
   * 更新应用名称
   *
   * @param appName 应用名
   */
  onUpdateAppName(appName: string): void {
    this.appName = appName;
  }
}