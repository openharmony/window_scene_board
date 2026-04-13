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

import { CommonUtils } from '@ohos/basicutils';
import { Equality } from '@ohos/basicutils';
import { LiveViewEnterImmersiveEvent, LiveViewExitImmersiveEvent, transResToPicHelper } from '@ohos/systemuicommon';
import { WantAgent } from '@kit.AbilityKit';
import { ImmersiveCardData } from './ImmersiveCardData';
import { ImmersiveCapsuleData } from './ImmersiveCapsuleData';
import {
  IImmersiveData
} from '@ohos/systemuicommon';
import {
  ParseResultType
} from '@ohos/systemuicommon';
import {
  ImmersiveShowType
} from '@ohos/systemuicommon';
import { LiveViewData } from '@ohos/systemuicommon';
import { appIconHelper } from '../../common/helper/ImmersiveAppIconHelper';
import image from '@ohos.multimedia.image';
import { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import { EvtBus } from '@ohos/frameworkwrapper';

/**
 * 沉浸式锁屏通知数据模型
 */
@Observed
export class ImmersiveNtfData implements Equality, IImmersiveData {
  /**
   * 复写IResult，数据解析结果
   */
  public resultType: ParseResultType = ParseResultType.MISS;

  public hashCode: string = ''; // 唯一标示

  /**
   * 通知唯一标示,分组标识
   */
  public groupKey: string = '';

  /**
   * 应用包名
   */
  public creatorBundleName: string = '';

  /**
   * 通知点击事件动作
   */
  public wantAgent: WantAgent = Object();

  private appIcon?: image.PixelMap | string | DrawableDescriptor; // 应用图标

  public appName?: string; // 应用名称

  /**
   * 沉浸式卡片数据
   */
  public cardData: ImmersiveCardData = new ImmersiveCardData();

  /**
   * 沉浸式锁屏胶囊数据
   */
  public capsuleData: ImmersiveCapsuleData = new ImmersiveCapsuleData();

  /**
   * 记录通知数据的id,用于区分数据的新增、更新等
   */
  public id: number = 0;

  /**
   * 数据当前是否在沉浸卡片中显示
   */
  private isShowingInCard: boolean = false;

  private showType: ImmersiveShowType = ImmersiveShowType.SHOW_CAPSULE; // 数据可显示类型

  private onShowTypeChange = (showType: ImmersiveShowType): void => { // 显示类型切换回调
    if (this.showType !== showType) {
      this.showType = showType;
      this.capsuleData?.setShowType(showType);
    }
  };

  /**
   * 复写，相等比较
   *
   * @param other 待比较对象
   * @returns true相等
   */
  equals(other: object): boolean {
    if (!(other instanceof ImmersiveNtfData)) {
      return false;
    }
    let otherData = other as ImmersiveNtfData;
    return this.groupKey === otherData.groupKey;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof ImmersiveNtfData)) {
      return;
    }
    let otherData = other as ImmersiveNtfData;
    transResToPicHelper.start(otherData.creatorBundleName);
    this.setHashCode(otherData.groupKey);
    this.setCreatorBundleName(otherData.creatorBundleName);
    this.setWantAgent(otherData.wantAgent);
    this.updateCardData(otherData.cardData, forceRefresh);
    this.updateCapsuleData(otherData.capsuleData, forceRefresh);
    transResToPicHelper.end();
  }

  /**
   * 图标数据切换提醒回调
   * 复写IImmersiveData
   */
  onAppIconChange(): void {
    let appIcon = appIconHelper.getAppIcon(this.hashCode);
    this.setAppIcon(appIcon);
  }

  /**
   * 应用名数据切换提醒回调
   * 复写IImmersiveData
   * @param appName
   */
  onUpdateAppName(appName: string): void {
    this.setAppName(appName);
  }

  /**
   * 是否显示沉浸卡片
   *
   * @returns boolean
   */
  shouldShowInImmersiveCard(): boolean {
    if (this.capsuleData?.isHideContent) {
      return false;
    }
    return (this.showType & ImmersiveShowType.SHOW_CARD) !== 0;
  }

  isUiExtensionCard(): boolean {
    return this.cardData?.isUiExtensionCard() ?? false;
  }

  /**
   * 是否显示锁屏胶囊
   *
   * @returns boolean
   */
  shouldShowInCapsule(): boolean {
    return (this.showType & ImmersiveShowType.SHOW_CAPSULE) !== 0;
  }

  /**
   * 删除显示场景
   *
   * @param showType 场景
   */
  deleteShowType(showType: ImmersiveShowType): void {
    this.cardData?.deleteShowType(showType);
  }

  /**
   * 新增显示场景
   *
   * @param showType 场景
   */
  addShowType(showType: ImmersiveShowType): void {
     this.cardData?.addShowType(showType);
  }

  /**
   * 设置当前数据是否正在沉浸卡片显示
   *
   * @param isShowInCard 是否在显示
   */
  setShowInCard(isShowInCard: boolean): void {
    this.isShowingInCard = isShowInCard;
    if (this.capsuleData && this.capsuleData.liveView) {
      this.capsuleData.liveView.isShowingInCard = isShowInCard;
      if (isShowInCard) {
        EvtBus.post(LiveViewEnterImmersiveEvent, new LiveViewEnterImmersiveEvent(this.capsuleData.liveView.hashCode));
      } else {
        EvtBus.post(LiveViewExitImmersiveEvent, new LiveViewExitImmersiveEvent(this.capsuleData.liveView.hashCode));
      }
    }
  }

  /**
   * 是否正在沉浸卡片显示中
   *
   * @returns
   */
  isShownInCard(): boolean {
    return this.isShowingInCard;
  }

  /**
   * 创建组通知
   */
  createGroup(): void {
    this.capsuleData?.createGroup();
  }

  /**
   * 删除分组数据
   */
  deleteGroup(): void {
    this.capsuleData?.deleteGroup();
  }

  /**
   * 添加子通知数据到分组
   *
   * @param child 子通知
   */
  addChildData(child: ImmersiveNtfData): void {
    this.capsuleData?.addChildData(child?.capsuleData);
  }

  /**
   * 设置通知是否隐藏
   *
   * @param isHideContent 是否隐藏
   */
  setNtfHide(isHideContent: boolean): void {
    this.capsuleData?.setNtfHide(isHideContent);
  }

  /**
   * 设置当前应用是否处于应用锁保护状态
   *
   * @param isAppLocked 是否处于上锁状态
   */
  setAppLocked(isAppLocked?: boolean): void {
    this.capsuleData?.setAppLocked(isAppLocked);
  }

  /**
   * 应用图标
   *
   * @param appIcon 图标
   * @param forceRefresh 强制刷新
   */
  setAppIcon(appIcon?: image.PixelMap | string | DrawableDescriptor, forceRefresh?: boolean): void {
    this.appIcon = appIcon;
    this.cardData?.setAppIcon(appIcon, forceRefresh);
    this.capsuleData?.setAppIcon(appIcon, forceRefresh);
  }

  /**
   * 应用名称
   *
   * @param appName 应用名
   * @param forceRefresh 强制刷新
   */
  setAppName(appName?: string, forceRefresh?: boolean): void {
    this.appName = appName;
    this.cardData?.setAppName(appName, forceRefresh);
    this.capsuleData?.setAppName(appName, forceRefresh);
  }

  /**
   * 更新卡片数据
   *
   * @param otherData 旧数据
   * @param forceRefresh 强制刷新
   */
  private updateCardData(otherData: ImmersiveCardData, forceRefresh?: boolean): void {
    if (forceRefresh || CommonUtils.isInvalid(this.cardData)) {
      this.setCardData(otherData, forceRefresh);
    } else {
      this.cardData?.update(otherData, forceRefresh);
    }
  }

  /**
   * 更新胶囊数据
   *
   * @param otherData 旧数据
   * @param forceRefresh 强制刷新
   */
  private updateCapsuleData(otherData: ImmersiveCapsuleData, forceRefresh?: boolean): void {
    if (forceRefresh || CommonUtils.isInvalid(this.capsuleData)) {
      this.setCapsuleData(otherData, forceRefresh);
    } else {
      this.capsuleData?.update(otherData, forceRefresh);
    }
  }

  /**
   * 设置hashCode
   *
   * @param hashCode 唯一标识
   * @param forceRefresh 强制刷新
   */
  setHashCode(hashCode: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(hashCode)) {
      this.groupKey = hashCode;
    }
  }

  /**
   * 设置应用包名
   *
   * @param hashCode 应用包名
   * @param forceRefresh 强制刷新
   */
  setCreatorBundleName(creatorBundleName: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(creatorBundleName)) {
      this.creatorBundleName = creatorBundleName;
    }
  }

  /**
   * 设置应用wantAgent
   *
   * @param wantAgent 应用WantAgent
   * @param forceRefresh 强制刷新
   */
  setWantAgent(wantAgent: WantAgent, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(wantAgent)) {
      this.wantAgent = wantAgent;
    }
  }

  /**
   * 设置沉浸式锁屏胶囊数据
   *
   * @param hashCode 沉浸式锁屏胶囊数据
   * @param forceRefresh 强制刷新
   */
  setCapsuleData(immersiveCapsuleData: ImmersiveCapsuleData, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(immersiveCapsuleData)) {
      this.capsuleData = immersiveCapsuleData;
      immersiveCapsuleData?.setShowType(this.showType); // 关联显示类型
      immersiveCapsuleData?.setAppIcon(this.appIcon);
      immersiveCapsuleData?.setAppName(this.appName);
    }
  }

  /**
   * 设置沉浸式锁屏卡片数据
   *
   * @param cardData 沉浸式锁屏卡片数据
   * @param forceRefresh 强制刷新
   */
  setCardData(cardData: ImmersiveCardData, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(cardData)) {
      this.cardData = cardData;
      cardData?.setShowTypeListener(this.onShowTypeChange); // 监听显示类型切换
      cardData?.setAppIcon(this.appIcon);
      cardData?.setAppName(this.appName);
    }
  }

  /**
   * 获取胶囊数据
   *
   * @returns ImmersiveCapsuleData
   */
  getCapsuleData(): ImmersiveCapsuleData {
    return this.capsuleData;
  }

  /**
   * 设置实况数据
   *
   * @param liveView 实况数据
   * @param forceRefresh 强制刷新
   */
  setLiveViewData(liveView?: LiveViewData, forceRefresh?: boolean): void {
    this.cardData?.setLiveView(liveView);
    this.cardData?.setCardLiveView(liveView);
    this.capsuleData?.setLiveView(liveView, forceRefresh);
  }

  toString(): string {
    return `id: ${this.id}, groupKey: ${this.groupKey}, status: ${this.isShowingInCard},
      capsule: ${this.capsuleData?.toString()}, card: ${this.cardData?.toString()}`;
  }
}