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
import { LogDomain, LogHelper, RectInfo, SingletonHelper } from '@ohos/basicutils';
import { ComponentAnimState, LiveViewDataArray } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { WidgetAnimState } from '../../base/bean/WidgetAnimState';
import { ComponentPosition } from '../../base/utils/ComponentPosition';

const TAG = 'ImmersiveLiveStateShareManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 实况胶囊被点击 或者实况列表Icon被点击
 */
type clickEvent = () => void;
/**
 * 沉浸实况动效场景枚举
 */
export enum ImmersiveLiveAnimSceneEnum {
  SCENE_LIVE_LIST_IMME_CARD_TRANSFORM = 'scene_live_list_imme_card_transform', // 实况列表沉浸卡片之间变换动效
  SCENE_LIVE_CAPSULE_IMME_CARD_TRANSFORM = 'scene_live_capsule_imme_card_transform', // 沉浸卡片实况胶囊之间变换动效
}

/**
 * 沉浸&实况的视图名称
 * CapsuleAnimName CardAnimType
 */
export enum ImmeLiveViewNameEnum {
  LIVE_CAPSULE_ROOT = 'live_capsule_root', //胶囊*
  LIVE_LIST_ROOT = 'live_list_root', //列表*
  IMMERSIVE_CARD_ROOT = 'immersive_card_root', //卡片*
}

/**
 * 用于沉浸实况动效的状态共享管理FoldPhoneTypeValue.EXPANDING_NEX_FORMS产品使用
 */
class ImmersiveLiveStateShareManager {
  /**
   * 锁屏实况列表图标点击监听
   */
  private liveCapsuleClick?: clickEvent;
  /**
   * 实况列表位置集合
   * 共享位置，动效使用
   */
  private liveListRectList: RectInfo[] = [];
  /**
   * 锁屏实况胶囊图标点击监听
   */
  private onIconClick?: clickEvent;
  /**
   * 实况胶囊数据
   */
  private shareLiveData: LiveViewDataArray = new LiveViewDataArray();
  /**
   * 实况列表项组件动效状态管理
   */
  private itemAnimStateMap?: Map<string, ComponentAnimState>;
  /**
   * 面板胶囊动效状态
   */
  private bannerCapsuleRootCmpState?: ComponentAnimState;
  /**
   * 状态栏胶囊动效状态
   */
  private capsuleListCmpState?: ComponentAnimState;
  /**
   * 实况列表根布局
   */
  private listRootCmpState?: ComponentAnimState;
  /**
   * 卡片根组件动效状态
   */
  private cardRootAnimState?: WidgetAnimState;
  /**
   * 卡片位置信息
   */
  private cardContentPos?: ComponentPosition = {
    width: 278,
    height: 108,
    globalX: 24,
    globalY: 194
  };

  /**
   * 动效打断方法
   */
  private interruptedExecutor?: (scene: ImmersiveLiveAnimSceneEnum) => void;

  public setInterruptedExecutor(interruptedExecutor: (scene: ImmersiveLiveAnimSceneEnum) => void): void {
    this.interruptedExecutor = interruptedExecutor;
  }

  /**
   * 取值实况列表位置缓存集
   *
   * @returns 位置集
   */
  public getLivRectList(): RectInfo[] {
    return this.liveListRectList;
  }

  public getInterruptedExecutor(): ((scene: ImmersiveLiveAnimSceneEnum) => void) | undefined {
    return this.interruptedExecutor;
  }

  public setBannerCapsuleCmpState(rootCapsuleState: ComponentAnimState): void {
    this.bannerCapsuleRootCmpState = rootCapsuleState;
  }

  public getBannerCapsuleCmpState(): ComponentAnimState | undefined {
    return this.bannerCapsuleRootCmpState
  }

  public setCapsuleCmpState(rootCapsuleState: ComponentAnimState): void {
    this.capsuleListCmpState = rootCapsuleState;
  }

  public getCapsuleCmpState(): ComponentAnimState | undefined {
    return this.capsuleListCmpState
  }

  public setCardRootAnimState(cardContentAnimState: WidgetAnimState): void {
    this.cardRootAnimState = cardContentAnimState;
  }

  public getCardRootAnimState(): WidgetAnimState | undefined {
    return this.cardRootAnimState
  }

  public setCardContentPos(cardContentPos?: ComponentPosition): void {
    this.cardContentPos = cardContentPos;
  }

  public getCardContentPos(): ComponentPosition | undefined {
    return this.cardContentPos;
  }

  public setLiveCapsuleClick(liveCapsuleClick: clickEvent): void {
    this.liveCapsuleClick = liveCapsuleClick;
  }

  public getLiveCapsuleClick(): clickEvent | undefined {
    return this.liveCapsuleClick;
  }

  public setOnIconClick(onIconClick: clickEvent): void {
    this.onIconClick = onIconClick;
  }

  public getOnIconClick(): clickEvent | undefined {
    return this.onIconClick;
  }

  public setShareLiveData(shareLiveData: LiveViewDataArray): void {
    this.shareLiveData = shareLiveData;
  }

  public getShareLiveData(): LiveViewDataArray {
    return this.shareLiveData;
  }

  public setItemAnimStateMap(itemAnimStateMap: Map<string, ComponentAnimState>): void {
    this.itemAnimStateMap = itemAnimStateMap;
  }

  public getItemAnimStateMap(): Map<string, ComponentAnimState> | undefined {
    return this.itemAnimStateMap;
  }

  public setListRootCmpState(listRootCmpState: ComponentAnimState): void {
    this.listRootCmpState = listRootCmpState;
  }

  public getListRootCmpState(): ComponentAnimState | undefined {
    return this.listRootCmpState;
  }

  /**
   * 取值对应条目位置
   *
   * @param hashCode 条目标识
   * @returns 条目位置
   */
  public getLiveListItemRect(hashCode: string): RectInfo | undefined {
    let targetIndex: number | undefined = undefined;
    this.shareLiveData.find((item, index) => {
      if (item.hashCode === hashCode) {
        targetIndex = index;
        return true;
      }
      return false;
    });
    if (targetIndex === undefined) {
      return undefined;
    }
    return this.liveListRectList[targetIndex];
  }
}

export const immeLiveStateShareMgr: ImmersiveLiveStateShareManager =
  SingletonHelper.getInstance(ImmersiveLiveStateShareManager, TAG);