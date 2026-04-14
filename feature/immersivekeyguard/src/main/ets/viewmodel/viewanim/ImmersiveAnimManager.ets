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
import { ImmersiveAnimKey, ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';
import { CapsulePositionType, CardAnimType } from '../../common/ImmersiveConstants';
import { ImmersiveCapsuleAnimManager } from './ImmersiveCapsuleAnimManager';
import { ImmersiveListAnimManager } from './ImmersiveListAnimManager';
import { ImmersiveTraceHelper } from '../../common/helper/ImmersiveTraceHelper';
import { ImmersiveCardAnimManager } from './ImmersiveCardAnimManager';
import { ImmersiveAnimStateManager } from './ImmersiveAnimStateManager';
import { SlClockAnimManager } from './SlClockAnimManager';
import {
  NotificationStateManager,
  WDefault,
  WAnimScene
} from '@ohos/screenlockcommon';
import { SlWidgetZIndex } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import {
  CmpPosWrapper,
  ComponentPosition,
  ImmersiveLiveAnimSceneEnum as ShareAnimScene,
  WidgetAnimState
} from '@ohos/screenlockcommon/Index';
import { ImmersiveCapsuleConstants } from '../../common/constants/ImmersiveCapsuleConstants';
import { NotificationConfig } from '@ohos/notificationcomponent/src/main/ets/common/NotificationConfig';
import { util } from '@kit.ArkTS';
import { AnimationController } from '@ohos/mediacontrolcomponent/src/main/ets/default/Controller/AnimationController';
import { ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { ObjectCopyUtil } from '@ohos/componenthelper'
import { ArrayUtils, CommonUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { AnimStyleType } from '../../model/data/anim/ImmersiveAnimStyle';
import {
  AnimDataScene,
  bannerMgr,
  BaseConstants,
  capsuleStateMgr,
  DefaultPanelZIndex,
  ImmersiveType
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { curves } from '@kit.ArkUI';
import { cardList } from '../viewdata/ImmersiveCardList';
import { ImmersiveLiveAnimManager } from './ImmersiveLiveAnimManager';
import { CapTypeChain } from '../../common/anim/CapTypeChain';
import { immersiveStateMgr } from '../../common/manager/ImmersiveStateManager';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { interruptHelper } from '../../common/helper/ImmersiveInterruptHelper';

const TAG = 'ImmersiveAnimManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 条目缓存数
 */
const ITEM_CACHE_COUNT = 2;
/**
 * 列表到卡片动效时延
 */
const TO_CARD_DELAY = 40;
/**
 * 条目动效延时间隔
 */
const ITEM_ANIM_DELAY = 50;

/**
 * 透明度动效执行时长
 */
const ALPHA_TIME = 200;

/**
 * 条目跟随时钟动效延时
 */
const DELAY_WITH_CLOCK = 80;

/**
 * 动效最小值
 */
const MIN = WDefault.MIN_VALUE;

/**
 * 动效最大值
 */
const MAX = WDefault.MAX_VALUE;

/**
 * 卡片高层级
 */
const CARD_Z_INDEX = SlWidgetZIndex.Z_INDEX_IMMERSIVE_CAP + 2;

const LIST_Z_INDEX = SlWidgetZIndex.Z_INDEX_IMMERSIVE_CAP + 1; // 列表高层级

const ITEM_Z_INDEX = Number.MAX_VALUE; // 列表item高层级

const ITEM_CLICK_SCALE = 0.95; // 通知item点击缩放值

const CLICK_ANIM = NotificationConfig.NOTIFICATION_CLICK_ANIM; // 点击复位动效曲线

/**
 * 动效结束类型
 */
type OnAnimFinish = () => void;

/**
 * 条目卡片参数传递
 */
interface ItemAnimParam {
  /**
   * 条目唯一标示
   */
  hashcode?: string;

  /**
   * 动效场景
   */
  animScene?: ImmersiveAnimScene;

  /**
   * 条目映射胶囊类型
   */
  mapCapsuleType?: CapsulePositionType;

  /**
   * 条目动效延时启动
   */
  animDelay?: number;

  /**
   * 是否为第一个条目
   */
  isFirstItem?: boolean;

  /**
   * 是否为最后一个条目
   */
  isLastItem?: boolean;

  /**
   * 条目索引
   */
  itemIndex?: number;

  /**
   * 条目可见起始索引
   */
  itemStartIndex?: number;

  /**
   * 条目可见结束索引
   */
  itemEndIndex?: number;

  /**
   * 速度
   */
  velocity?: number;

  /**
   * 是否为次要动效
   */
  isSecondaryAnim?: boolean;

  /**
   * 是否动效初始化
   */
  isAnimInit?: boolean;

  /**
   * 条目当前显示位置
   */
  itemTarPos?: CmpPosWrapper;

  /**
   * 参与动效条目标识集
   */
  itemList?: ItemAnimParam[];

  /**
   * 条目动效结束回调
   *
   * @param isLastItem 是否为最后一个条目
   */
  onAnimFinish?: (param: ItemAnimParam) => void;

  /**
   * 条目目标动作
   *
   * @param param 参数
   */
  tarItemAction?: (param: ItemAnimParam) => void;

  /**
   * 非条目目标动作
   *
   * @param param 参数
   */
  excludeTarItemAction?: (param: ItemAnimParam) => void;

  /**
   * 动效结束回调
   */
  callback?: OnAnimFinish;
}

/**
 * 沉浸锁屏动效管理
 */
export class ImmersiveAnimManager {
  /**
   * 沉浸式动效状态管理器
   */
  private animStMgr: ImmersiveAnimStateManager = new ImmersiveAnimStateManager();
  /**
   * 列表动效统一管理
   */
  private listAnimMgr: ImmersiveListAnimManager = new ImmersiveListAnimManager();
  /**
   * 胶囊动效统一管理
   */
  private capsuleAnimMgr: ImmersiveCapsuleAnimManager = new ImmersiveCapsuleAnimManager();
  /**
   * 沉浸卡片动效统一管理
   */
  private cardAnimMgr: ImmersiveCardAnimManager = new ImmersiveCardAnimManager();
  /**
   * 锁屏时钟动效管理
   */
  private slClockAnimMgr: SlClockAnimManager = new SlClockAnimManager();
  /**
   * 沉浸实况动效，作用于EXPANDING_NEX_FORMS设备外屏
   */
  private immeLiveAnimMgr: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();

  /**
   * 开始列表到卡片动效
   */
  public startList2CardFixAnim(hashcode?: string): void {
    this.animStMgr.exeAnimScenePreProcessing(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);
    log.showInfo('ListToCard start');
    if (this.isMediaCenterAnim()) {
      AnimationController.startListToCardAnim();
    }
    if (!hashcode) {
      log.showWarn('startListToCardFixAnim hashcode is null');
      this.listAnimMgr?.updateLongClickAnim();
      return;
    }
    if (!this.checkListAndCardPositionStatus(hashcode)) {
      log.showWarn('startListToCardFixAnim anim status failed');
      this.listAnimMgr?.updateLongClickAnim();
      return;
    }
    this.startList2CapsuleFixAnim(0, hashcode);
    this.execList2CardAnim(hashcode);
  }

  /**
   * 开始卡片到列表动效
   */
  public startCardToListFixAnim(vel: number = 0) {
    this.animStMgr.exeAnimScenePreProcessing(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT);
    let isIconSharingAnim: boolean = this.cardAnimMgr?.isMediaCenterAnim() ?? false;
    if (isIconSharingAnim) {
      AnimationController.startCardToListAnim();
    }
    this.cardAnimMgr?.fillImmersiveCardAnimData();
    immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_LIST); // 退出到列表态
    log.showInfo('CardToList start');
    let hashcode = this.cardAnimMgr.getImmersiveCardData()?.animShowData?.groupKey;
    if (hashcode === undefined) {
      log.showWarn('startCardToListFixAnim hashcode is null');
      return;
    }
    if (!this.checkListAndCardPositionStatus(hashcode)) {
      log.showWarn('startListToCardFixAnim anim status failed');
      return;
    }
    this.startCapsule2ListFixAnim(vel, hashcode);
    this.exeCard2ListAnim(hashcode, isIconSharingAnim);
  }

  /**
   * 开始实况列表到沉浸卡片动效
   */
  public startLiveListToImmeCardFixAnim(hashcode: string | undefined) {
    let scene = ShareAnimScene.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM;
    this.immeLiveAnimMgr.interruptedExecutor(scene);
    // 此处胶囊动效面板显示只起动效作用不参与动效
    let preAction = () => {
      if (SystemUICcmConfig.instance.isEnabledLive2) {
        return;
      }
      ViewManagerPolicy.setZIndex(ViewType.NOTIFICATION_BANNER, DefaultPanelZIndex.PANEL_STATUS_BAR + 1);
      bannerMgr.requestPanelCapsuleList();
    }
    let afterAction = () => {
      if (SystemUICcmConfig.instance.isEnabledLive2) {
        return;
      }
      bannerMgr.releasePanelCapsuleList();
    }
    this.immeLiveAnimMgr.setAnimAction(scene, preAction, afterAction);
    this.immeLiveAnimMgr.triggerExecutor(scene, true, hashcode);
  }

  /**
   * 沉浸卡片到实况列表
   */
  public startImmeCardToLiveListFixAnim(hashcode: string | undefined) {
    let scene = ShareAnimScene.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM;
    let afterAction = () => {
      ViewManagerPolicy.setZIndex(ViewType.NOTIFICATION_BANNER, DefaultPanelZIndex.PANEL_GESTURE_TOP_BAR - 1);
      this.cardAnimMgr.clearImmersiveCardAnimData();
    }
    this.immeLiveAnimMgr.setAnimAction(scene, undefined, afterAction);
    this.immeLiveAnimMgr.triggerExecutor(scene, false, hashcode);
  }

  /**
   * 开始沉浸卡片到实况胶囊
   */
  public startImmeCardToLiveCapsuleFixAnim(hashcode: string | undefined) {
    this.immeLiveAnimMgr.interruptedExecutor(ShareAnimScene.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM);
    let scene = ShareAnimScene.SCENE_LIVE_CAPSULE_IMME_CARD_TRANSFORM;
    let preAction = () => {
      let isTop = capsuleStateMgr.getCapsuleState().topCapsule?.hashCode === hashcode;
      let zIndex = (isTop ? DefaultPanelZIndex.PANEL_STATUS_BAR : DefaultPanelZIndex.PANEL_SCREEN_LOCK) + 1;
      ViewManagerPolicy.setZIndex(ViewType.NOTIFICATION_BANNER, zIndex);
      bannerMgr.requestPanelCapsuleList();
    }

    let afterAction = () => {
      ViewManagerPolicy.setZIndex(ViewType.NOTIFICATION_BANNER, DefaultPanelZIndex.PANEL_GESTURE_TOP_BAR - 1);
      capsuleStateMgr.getCapsuleState()?.setAnimCapsuleData(AnimDataScene.SCENE_IMME_LIVE, undefined);
      bannerMgr.releasePanelCapsuleList();
      this.cardAnimMgr.clearImmersiveCardAnimData();
    }
    this.immeLiveAnimMgr.setAnimAction(scene, preAction, afterAction);
    this.immeLiveAnimMgr.triggerExecutor(scene, true, hashcode);
  }

  /**
   * 得到沉浸实况动效管理器
   *
   * @returns 动效管理
   */
  getImmeLiveAnimMgr(): ImmersiveLiveAnimManager {
    return this.immeLiveAnimMgr;
  }

  /**
   * 设置沉浸锁屏列表数据
   *
   * @returns 动效管理
   */
  getCapsuleAnimMgr(): ImmersiveCapsuleAnimManager {
    return this.capsuleAnimMgr;
  }

  /**
   * 沉浸列表动效管理器
   *
   * @returns 动效管理
   */
  getListAnimMgr(): ImmersiveListAnimManager {
    return this.listAnimMgr;
  }

  /**
   * 沉浸卡片动效管理器
   *
   * @returns 动效管理
   */
  getCardAnimMgr(): ImmersiveCardAnimManager {
    return this.cardAnimMgr;
  }

  /**
   * 锁屏时钟组件动效管理器
   *
   * @returns 动效管理
   */
  getSlClockAnimMgr(): SlClockAnimManager {
    return this.slClockAnimMgr;
  }

  /**
   * 设置列表组件显示位置
   *
   * @param animKey 标示
   * @param area 显示位置
   */
  setListViewArea(animKey?: string, area?: Area | SizeOptions): void {
    if (CommonUtils.isInvalid(animKey)) {
      return;
    }
    // 列表根组件
    if (animKey === ImmersiveAnimKey.IMMERSIVE_LIST_ROOT) {
      this.listAnimMgr.setRootViewArea(area);
    } else { // 子组件
      this.listAnimMgr.setChildViewArea(animKey!, area);
    }
  }

  /**
   * 设置胶囊组件显示位置
   *
   * @param animKey 标识
   * @param area 显示位置
   */
  setCapsuleViewArea(animKey: ImmersiveAnimKey | CapsulePositionType, area?: Area | SizeOptions): void {
    // 胶囊根组件
    if (animKey === ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT) {
      this.capsuleAnimMgr.setRootViewArea(area);
    } else {
      this.capsuleAnimMgr.setChildViewArea(animKey as CapsulePositionType, area);
    }
  }

  /**
   * 得到Capsule组件显示位置
   */
  getCapsuleViewArea(animKey?: CapsulePositionType): ComponentPosition {
    if (animKey) {
      this.capsuleAnimMgr.getChildViewPosition(animKey as CapsulePositionType);
    }
    // 胶囊根组件
    return this.capsuleAnimMgr.getRootViewPosition();
  }

  /**
   * 设置card组件显示位置
   */
  setCardViewArea(animKey?: CardAnimType | ImmersiveAnimKey, area?: Area): void {
    // 卡片根组件
    if (animKey === ImmersiveAnimKey.IMMERSIVE_CARD_ROOT) {
      this.cardAnimMgr.setRootViewArea(area);
    } else {
      this.cardAnimMgr.setChildViewArea(animKey as CardAnimType, area);
    }
  }

  /**
   * 得到card组件显示位置
   */
  getCardViewArea(animKey?: CardAnimType): ComponentPosition {
    if (animKey) {
      this.cardAnimMgr.getChildViewPosition(animKey as CardAnimType);
    }
    // 卡片根组件
    return this.cardAnimMgr.getRootViewPosition();
  }

  /**
   * 胶囊绑定数据标识
   *
   * @param type 胶囊类型
   * @param hashcode 标识
   */
  bindCapsuleAnimKey(type: CapsulePositionType, hashcode?: string): void {
    this.capsuleAnimMgr.refreshHashcode(type, hashcode);
  }

  /**
   * 设置列表动效UI样式
   *
   * @param animKey 标示
   * @param type 样式类型
   * @param value 值
   */
  setListAnimStyle(animKey: string, type: AnimStyleType, value?: number): void {
    if (CommonUtils.isInvalid(animKey)) {
      return;
    }
    // 列表根组件
    if (animKey === ImmersiveAnimKey.IMMERSIVE_LIST_ROOT) {
      this.listAnimMgr.setRootStyleValue(type, value);
    } else { // 子组件
      this.listAnimMgr.setChildStyleValue(animKey, type, value);
    }
  }

  /**
   * 获取卡片组件动效状态
   *
   * @param animKey 标识
   * @returns 动效状态
   */
  getCardAnimState(animKey: ImmersiveAnimKey | CardAnimType): WidgetAnimState {
    if (animKey === ImmersiveAnimKey.IMMERSIVE_CARD_ROOT) {
      return this.cardAnimMgr.getRootAnimState();
    }
    return (this.cardAnimMgr.getChildAnimState(animKey as CardAnimType));
  }

  /**
   * 设置胶囊组件动效UI样式
   *
   * @param animKey 标识
   * @param type 样式类型
   * @param value 值
   */
  setCapsuleAnimStyle(animKey: ImmersiveAnimKey | CapsulePositionType, type: AnimStyleType, value?: number): void {
    // 胶囊根组件
    if (animKey === ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT) {
      this.capsuleAnimMgr.setRootStyleValue(type, value);
    } else {
      this.capsuleAnimMgr.setChildStyleValue(animKey as CapsulePositionType, type, value);
    }
  }

  /**
   * 获取列表组件动效状态
   *
   * @param animKey 标识
   * @returns 动效状态
   */
  getListAnimState(animKey?: string): WidgetAnimState | undefined {
    if (CommonUtils.isInvalid(animKey)) {
      return undefined;
    }
    if (animKey === ImmersiveAnimKey.IMMERSIVE_LIST_ROOT) {
      return this.listAnimMgr.getRootAnimState();
    }
    return this.listAnimMgr.getChildAnimState(animKey!);
  }

  /**
   * 获取组件位置
   *
   * @param animKey 标识
   * @returns 组件位置
   */
  getListViewPosition(animKey?: string): ComponentPosition | undefined {
    if (CommonUtils.isInvalid(animKey)) {
      return undefined;
    }
    if (animKey === ImmersiveAnimKey.IMMERSIVE_LIST_ROOT) {
      return this.listAnimMgr.getRootViewPosition();
    }
    return this.listAnimMgr.getChildViewPosition(animKey!);
  }

  /**
   * 移除列表子组件动效状态
   *
   * @param animKey 标识
   */
  removeListAnimState(animKey: string): void {
    this.listAnimMgr.removeChildAnimState(animKey);
  }

  /**
   * 获取胶囊动效状态
   *
   * @param animKey 标识
   * @returns 动效状态
   */
  getCapsuleAnimState(animKey: ImmersiveAnimKey | CapsulePositionType): WidgetAnimState | undefined {
    if (animKey === ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT) {
      return this.capsuleAnimMgr.getRootAnimState();
    }
    return this.capsuleAnimMgr.getChildAnimState(animKey as CapsulePositionType);
  }

  /**
   * 打断动效
   *
   * @param scene 动效场景
   */
  interruptAnimScene(scene: ImmersiveAnimScene): void {
    this.animStMgr.exeAnimSceneFinish(scene);
  }

  /**
   * 列表过渡胶囊跟手复位动效
   *
   * @param vel 速度
   */
  startList2CapsuleTouchBackAnim(vel: number = 0): void {
    log.showInfo('ListToCapsuleTouchBack start');
    let scene = ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK;
    ImmersiveTraceHelper.startAnimTrace(scene);
    let rootState = this.listAnimMgr.getRootAnimState();
    rootState.setAnimScene({ isAnimating: true, animScene: scene });
    this.slClockAnimMgr.startClockAnimScene(scene); // 时钟组件跟随
    let rootParam: ItemAnimParam = { animScene: scene, velocity: vel };
    rootParam.isAnimInit = true;
    rootParam.tarItemAction = this.initList2CapsuleBackItem;
    this.forList2CapsuleItem(rootParam); // 初始化
    let animFinish = (): void => {
      if (!this.animStMgr.hasAnimSceneFinish(scene)) { // 动效已被打断
        return;
      }
      rootParam.isAnimInit = false;
      rootParam.tarItemAction = this.finishList2CapsuleItem;
      this.forList2CapsuleItem(rootParam);
      this.clearAnimStateProperty(rootState, scene);
      this.slClockAnimMgr.clearClockAnimState(scene);
      ImmersiveTraceHelper.endAnimTrace(scene);
      log.showInfo('ListToCapsuleTouchBack end');
    };
    this.animStMgr.addAnimSceneFinish(scene, { onAnimFinish: animFinish }); // 缓存动效
    animateToImmediately(this.getMainAnimParams(scene, vel,
      { onFinish: () => this.animStMgr.exeAnimSceneFinish(scene) }), () => {
      rootParam.isAnimInit = false;
      rootParam.tarItemAction = this.startList2CapsuleBackItem;
      this.forList2CapsuleItem(rootParam);
      this.slClockAnimMgr.endClockAnimState(); // 时钟组件跟随
    });
  }

  /**
   * 开启列表固定过渡到胶囊动效
   *
   * @param vel 跟手速度
   * @param skipAnimKey 跳过动效的条目标识
   * @param callback 动效结束回调
   */
  startList2CapsuleFixAnim(vel: number = 0, skipAnimKey?: string, callback?: OnAnimFinish): void {
    // 动效前，打断胶囊过渡列表动效，打断列表下拉回退动效
    this.animStMgr.exeAnimScenePreProcessing(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);
    log.showInfo('ListToCapsule start');
    let scene = ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX;
    this.listAnimMgr.setRootAnimating(true, scene);
    this.capsuleAnimMgr.setRootAnimating(true, scene);
    let rootParam: ItemAnimParam = { hashcode: skipAnimKey, animScene: scene, velocity: vel };
    rootParam.isAnimInit = true;
    rootParam.tarItemAction = this.initList2CapsuleFixItem;
    rootParam.excludeTarItemAction = this.initList2CapsuleFixExcludeItem;
    if (!this.forList2CapsuleItem(rootParam)) { // 初始化，无有效条目
      this.listAnimMgr.setRootAnimating(false, scene);
      this.capsuleAnimMgr.setRootAnimating(false, scene);
      callback?.();
      return;
    }
    rootParam.excludeTarItemAction = undefined;
    this.animStMgr.setBlurFreezeState(true, scene); // 冻结模糊
    let isClockEnable = this.slClockAnimMgr.hasClockTranY();
    if (isClockEnable) {
      this.slClockAnimMgr.startClockAnimScene(scene); // 时钟跟随
    }
    rootParam.isAnimInit = false;
    rootParam.callback = callback;
    rootParam.tarItemAction = this.setList2CapsuleItemEndValue;
    let delay = NotificationStateManager.notificationState.isClockAnimDelay && skipAnimKey ? TO_CARD_DELAY : 0;
    ImmersiveTraceHelper.startAnimTrace(scene);
    animateTo(this.getMainAnimParams(scene, vel, {
      onFinish: this.getList2CapsuleFinish(rootParam),
      delay: delay
    }), () => {
      this.forList2CapsuleItem(rootParam);
      if (isClockEnable) {
        this.slClockAnimMgr.endClockAnimState(); // 时钟跟随
      }
    });
    rootParam.tarItemAction = this.setList2CapsuleItemSecondary;
    animateTo(this.getSecondaryAnimParams(scene, { delay: delay }), () => {
      this.forList2CapsuleItem(rootParam);
    });
  }

  /**
   * 胶囊跟手结束后，阈值不足，开启恢复动效
   *
   * @param vel 速度
   */
  startCapsule2ListTouchBackAnim(vel: number = 0): void {
    log.showInfo('CapsuleToListTouchBack start');
    // 标记动效中
    let scene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK;
    ImmersiveTraceHelper.startAnimTrace(scene);
    this.capsuleAnimMgr.setRootAnimating(true, scene);
    this.slClockAnimMgr.startClockAnimScene(scene);
    let contentState = this.getCapsuleAnimState(CapsulePositionType.TYPE_CONTENT);
    let shadowState = this.getCapsuleAnimState(CapsulePositionType.TYPE_SHADOW);
    contentState?.setAnimScene({ isAnimating: true, animScene: scene });
    shadowState?.setAnimScene({ isAnimating: true, animScene: scene });
    let animFinish = (): void => {
      if (!this.animStMgr.hasAnimSceneFinish(scene)) { // 动效已被打断
        return;
      }
      ImmersiveTraceHelper.endAnimTrace(scene);
      this.slClockAnimMgr.clearClockAnimState(scene);
      this.resetCapAnimState(scene);
      log.showInfo('CapsuleToListTouchBack end');
    };
    this.animStMgr.addAnimSceneFinish(scene, { onAnimFinish: animFinish }); // 缓存动效
    animateTo(this.getMainAnimParams(scene, vel,
      { onFinish: () => this.animStMgr.exeAnimSceneFinish(scene) }), () => {
      contentState?.setTranY(MIN);
      shadowState?.setTranY(MIN);
      this.slClockAnimMgr.endClockAnimState();
    });
  }

  /**
   * 开启胶囊固定过渡到列表动效
   *
   * @param vel 速度
   * @param skipCode 跳过动效条目标识
   * @param callback 动效结束回调
   */
  startCapsule2ListFixAnim(vel: number = 0, skipCode?: string, callback?: OnAnimFinish): void {
    // 动效前，打断列表过渡胶囊动效，打断胶囊上滑回退动效
    this.animStMgr.exeAnimScenePreProcessing(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT);
    log.showInfo('CapsuleToList start');
    // 跟随时钟元素延时
    let clockDelay = NotificationStateManager.notificationState.isClockAnimDelay ? DELAY_WITH_CLOCK : 0;
    let rootParam: ItemAnimParam = {
      hashcode: skipCode,
      velocity: vel,
      callback: callback,
      animScene: ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX,
      animDelay: clockDelay
    };
    if (!this.initCapsule2ListFixAnim(rootParam)) {
      return;
    }
    let chain: CapTypeChain | undefined = this.capsuleAnimMgr.getDefaultCapChain();
    this.listAnimMgr.getListData()?.find((entry, index) => {
      rootParam.itemIndex = index;
      rootParam.mapCapsuleType = chain?.getCapType() ?? CapsulePositionType.TYPE_NONE;
      if (!this.handleCapsule2ListItemAnim(rootParam, entry.getGroupKey())) {
        return rootParam.isLastItem ?? false;
      }
      chain = chain?.getNext();
      return rootParam.isLastItem ?? false;
    });
  }

  /**
   * 开启胶囊到沉浸卡片动效
   *
   * @param callback 动效执行完毕监听
   */
  startCapsuleToCardAnim(callback?: () => void, oldCapsulePosition?: ComponentPosition, isToggle?: boolean): void {
    this.animStMgr.exeAnimScenePreProcessing(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT);
    log.showInfo('CapsuleToCard Start');
    let param: ItemAnimParam = { animScene: ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD };
    this.initCapsuleToCardAnim(param, oldCapsulePosition);
    this.handleCapsuleToCardAnim(param, callback, isToggle);
  }

  /**
   * 触发卡片到胶囊动效
   *
   * @param callback 回调
   */
  startCardToCapsuleAnim(isToggle: boolean = false, callback?: () => void): void {
    this.animStMgr.exeAnimScenePreProcessing(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT);
    log.showInfo('CardToCapsule start');
    if (this.isMediaCenterAnim() && !isToggle) {
      AnimationController.startCardToCapsuleAnim();
    }
    let param: ItemAnimParam = { animScene: ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE };
    let oldArea = this.cardAnimMgr.getRootViewArea() as Area;
    this.initCardToCapsuleAnim(param, isToggle);
    this.handleCardToCapsuleAnim(param, callback, isToggle, oldArea);
  }

  private checkListAndCardPositionStatus(hashcode: string): boolean {
    let cardPosition = CmpPosWrapper.wrapper(this.cardAnimMgr.getRootViewPosition());
    let listPosition = CmpPosWrapper.wrapper(this.listAnimMgr.getChildViewPosition(hashcode));
    return cardPosition.isPosValid() && listPosition.isPosValid();
  }

  private setAnimating(isAnimating: boolean, scene: string, ...states: (WidgetAnimState | undefined)[]): void {
    states?.forEach((state) => state?.setAnimScene({ isAnimating: isAnimating, animScene: scene }));
  }

  private execList2CardAnim(hashcode: string) {
    let scene = ImmersiveAnimScene.SCENE_LIST_TO_CARD;
    let itemSt = this.listAnimMgr.getChildAnimState(hashcode);
    let itemInnerSt = itemSt?.getChildState(hashcode);
    let listRoot = this.listAnimMgr.getRootAnimState();
    listRoot.setZIndex(LIST_Z_INDEX); // 提高层级
    let cardSt = this.cardAnimMgr.getRootAnimState();
    this.setAnimating(true, scene, cardSt, itemSt, listRoot, itemInnerSt);
    let cardPosition = CmpPosWrapper.wrapper(this.cardAnimMgr.getRootViewPosition());
    let listPosition = CmpPosWrapper.wrapper(this.listAnimMgr.getChildViewPosition(hashcode));
    let cardRadius = this.cardAnimMgr.getRootAnimStyle().getValueDefault(AnimStyleType.RADIUS);
    let listRadius = this.listAnimMgr.getChildAnimStyle(hashcode).getValueDefault(AnimStyleType.RADIUS);
    let tranY = listPosition.getCmpGlobalY() - cardPosition.getCmpGlobalY();
    let tranX = listPosition.getCmpCenterX() - cardPosition.getCmpCenterX();
    let cardH = cardPosition.getCmpHeight();
    let cardW = cardPosition.getCmpWidth();
    let listH = listPosition.getCmpHeight();
    let listW = listPosition.getCmpWidth();
    let clickScale = ITEM_CLICK_SCALE;
    this.listAnimMgr.updateDisableEffect(hashcode, true); // 临时关闭模糊
    let staticW = Math.max(listW, cardW); // 卡片图片宽度过渡
    cardSt.setHeight(cardH)
      .setWidth(staticW)
      .setAlpha(MIN)
      .setTranY(tranY)
      .setTranX(tranX)
      .setBorderRadius(listRadius)
      .setClipWidth(listW)
      .setClipHeight(listH)
      .setScaleX(clickScale)
      .setScaleY(clickScale)
      .setZIndex(CARD_Z_INDEX);
    itemSt?.setHeight(listH).setWidth(listW)
      .setClipHeight(listH)
      .setClipWidth(listW)
      .setClip(true)
      .setZIndex(ITEM_Z_INDEX);
    itemInnerSt?.setScaleX(clickScale).setScaleY(clickScale).setUseEffect(true);
    ImmersiveTraceHelper.startAnimTrace(scene);
    this.animStMgr.addAnimSceneFinish(scene, {
      onAnimFinish: () => { // 缓存动效finish
        // 释放拦截器
        interruptHelper.animListCardIt.releaseInterrupt();
        this.clearAnimStateProperty(cardSt, scene);
        this.clearAnimStateProperty(itemSt, scene);
        this.clearAnimStateProperty(listRoot, scene);
        this.listAnimMgr?.updateLongClickAnim();
        ImmersiveTraceHelper.endAnimTrace(scene);
        log.showInfo('ListToCard end');
      }
    });
    // 请求finish拦截
    interruptHelper.animListCardIt.requestInterrupt();
    tranX = cardW > listW ? tranX + (cardW - listW) / BaseConstants.DIVIDE : tranX; // 超出ListItem宽度时，左侧被限制，补位移
    let delay = NotificationStateManager.notificationState.isClockAnimDelay ? TO_CARD_DELAY : 0; // 跟随时钟元素时延
    animateTo(this.getMainAnimParams(scene, 0, { delay: delay, onFinish: () => this.interruptAnimScene(scene) }),
      () => {
        cardSt.setTranY(MIN)
          .setTranX(MIN)
          .setWidth(cardW)
          .setClipWidth(cardW)
          .setClipHeight(cardH)
          .setBorderRadius(cardRadius);
        itemSt?.setTranY(-tranY).setTranX(-tranX).setClipHeight(cardH).setClipWidth(cardW).setBorderRadius(cardRadius);
      });
    this.exeLis2CardtAlphaAnim(cardSt, itemSt, scene, delay);
    animateTo(CLICK_ANIM, () => { // 按压恢复
      cardSt.setScaleX(MAX).setScaleY(MAX);
      itemInnerSt?.setScaleX(MAX).setScaleY(MAX);
    });
  }

  private exeLis2CardtAlphaAnim(cardSt: WidgetAnimState, itemSt: WidgetAnimState,
    scene: ImmersiveAnimScene, delay: number) {
    if (this.isMediaCenterAnim()) {
      cardSt.setAlpha(MAX);
      itemSt?.setAlpha(MIN);
    } else {
      animateTo(this.getSecondaryAnimParams(scene, { delay: delay }), () => { // 渐显渐隐
        cardSt.setAlpha(MAX);
        itemSt?.setAlpha(MIN);
      });
    }
  }

  /**
   * 动效前处理, 重置状态
   *
   * @param scene 动效场景
   */
  exeAnimScenePreProcessing(scene?: ImmersiveAnimKey): void {
    this.animStMgr.exeAnimScenePreProcessing(scene);
  }

  private exeCard2ListAnim(hashcode: string, isIconSharingAnim: boolean = false) { // 开启卡片到列表动效
    let scene = ImmersiveAnimScene.SCENE_CARD_TO_LIST;
    let itemSt = this.listAnimMgr.getChildAnimState(hashcode);
    let itemInnerSt = itemSt?.getChildState(hashcode);
    let listRoot = this.listAnimMgr.getRootAnimState();
    let cardSt = this.cardAnimMgr.getRootAnimState();
    this.setAnimating(true, scene, cardSt, itemSt, listRoot, itemInnerSt);
    let cardRadius = this.getCardAnimMgr().getRootAnimStyle().getValueDefault(AnimStyleType.RADIUS);
    let listRadius = this.listAnimMgr.getChildAnimStyle(hashcode).getValueDefault(AnimStyleType.RADIUS);
    let cardPosition = CmpPosWrapper.wrapper(this.cardAnimMgr.getRootViewPosition());
    let listPosition = CmpPosWrapper.wrapper(this.listAnimMgr.getChildViewPosition(hashcode));
    let tranY = listPosition.getCmpGlobalY() - cardPosition.getCmpGlobalY();
    let tranX = listPosition.getCmpCenterX() - cardPosition.getCmpCenterX();
    let cardH = cardPosition.getCmpHeight();
    let cardW = cardPosition.getCmpWidth();
    let listH = listPosition.getCmpHeight();
    let listW = listPosition.getCmpWidth();

    this.listAnimMgr.updateDisableEffect(hashcode, true); // 临时关闭模糊
    cardSt.setHeight(cardH).setWidth(cardW).setZIndex(CARD_Z_INDEX); // 动效前置状态处理
    // 超出ListItem宽度时，左侧被限制，补位移
    let listTranX = cardW > listW ? (tranX + (cardW - listW) / BaseConstants.DIVIDE) : tranX;
    itemSt?.setWidth(listW).setHeight(listH)
      .setClipWidth(cardW)
      .setClipHeight(cardH)
      .setAlpha(MIN)
      .setTranY(-tranY)
      .setTranX(-listTranX)
      .setBorderRadius(cardRadius)
      .setClip(true)
      .setZIndex(ITEM_Z_INDEX);
    itemInnerSt?.setUseEffect(true);
    listRoot?.setZIndex(LIST_Z_INDEX); // 提高层级

    this.animStMgr.addAnimSceneFinish(scene, {
      onAnimFinish: () => { // 缓存动效finish
        this.cardAnimMgr.clearImmersiveCardAnimData();
        this.clearAnimStateProperty(cardSt, scene);
        this.clearAnimStateProperty(itemSt, scene);
        this.clearAnimStateProperty(listRoot, scene);
        ImmersiveTraceHelper.endAnimTrace(scene);
        log.showInfo('CardToList end');
      }
    });
    ImmersiveTraceHelper.startAnimTrace(scene);
    let staticW = Math.max(listW, cardW);
    animateTo(this.getMainAnimParams(scene, 0, { onFinish: () => this.animStMgr.exeAnimSceneFinish(scene) }), () => {
      itemSt?.setClipHeight(listH).setClipWidth(listW).setTranX(MIN).setTranY(MIN).setBorderRadius(listRadius);
      cardSt.setClipHeight(listH)
        .setClipWidth(listW)
        .setTranY(tranY)
        .setTranX(tranX)
        .setWidth(staticW)
        .setBorderRadius(listRadius);
    });
    if (isIconSharingAnim) {
      cardSt.setAlpha(MIN);
      itemSt?.setAlpha(MAX);
    } else {
      animateTo(this.getSecondaryAnimParams(scene), () => { // 渐显渐隐
        cardSt.setAlpha(MIN);
        itemSt?.setAlpha(MAX);
      });
    }
  }

  private initCapsuleToCardAnim(param: ItemAnimParam, oldCapsulePosition?: ComponentPosition): void {
    let capsuleRootState = this.capsuleAnimMgr.getRootAnimState();
    let capAnimContent = this.capsuleAnimMgr.getChildAnimState(CapsulePositionType.TYPE_ANIM_CONTENT);
    let capsulePositionWrapper = CmpPosWrapper.wrapper(oldCapsulePosition);
    let cardState = this.cardAnimMgr.getRootAnimState();
    let cardPositionWrapper = CmpPosWrapper.wrapper(this.cardAnimMgr.getRootViewPosition());

    let tranY = capsulePositionWrapper.getCmpGlobalY() - cardPositionWrapper.getCmpGlobalY();
    let tranX = capsulePositionWrapper.getCmpCenterX() - cardPositionWrapper.getCmpCenterX();
    let capStyle = this.capsuleAnimMgr.getCapValidStyle(CapsulePositionType.TYPE_ANIM_CONTENT);

    // 状态初始化
    let anim: WAnimScene = { isAnimating: true, animScene: param?.animScene };
    capsuleRootState.setAnimScene(anim);

    // 动效胶囊参数初始化
    let radius = capStyle.getValueDefault(AnimStyleType.RADIUS);
    capAnimContent?.setAnimScene(anim).setClip(true).setAlpha(MAX).setBorderRadius(radius);

    // 内容卡片参数初始化
    cardState.setAnimScene(anim)
      .setZIndex(CARD_Z_INDEX)
      .setTranX(tranX)
      .setTranY(tranY)
      .setWidth(cardPositionWrapper?.getCmpWidth())
      .setHeight(cardPositionWrapper?.getCmpHeight())
      .setClipWidth(capsulePositionWrapper.getCmpWidth())
      .setClipHeight(capsulePositionWrapper.getCmpHeight())
      .setBorderRadius(radius)
      .setAlpha(MIN);
  }

  private handleCapsuleToCardAnim(param: ItemAnimParam, callback?: () => void, isToggle?: boolean): void {
    let capAnimContent = this.capsuleAnimMgr.getChildAnimState(CapsulePositionType.TYPE_ANIM_CONTENT);
    let cardState = this.cardAnimMgr.getRootAnimState();
    let cardPositionWrapper = CmpPosWrapper.wrapper(this.cardAnimMgr.getRootViewPosition());

    let radius = this.getCardAnimMgr().getRootAnimStyle().getValueDefault(AnimStyleType.RADIUS);

    // 动效完成，复位
    let animFinish = (): void => {
      callback?.();
      this.resetCapAnimState(param.animScene);
      this.clearAnimStateProperty(cardState, param.animScene);
      ImmersiveTraceHelper.endAnimTrace(param.animScene);
      log.showInfo('CapsuleToCard end');
    };

    let key: string = util.generateRandomUUID();
    this.animStMgr.addAnimSceneFinish(param.animScene, { onAnimFinish: animFinish, key: key }); // 缓存动效

    ImmersiveTraceHelper.startAnimTrace(param.animScene);
    animateTo(this.getMainAnimParams(param.animScene, 0, {
      onFinish: () => this.animStMgr.exeAnimSceneFinish(param.animScene, key)
    }), () => {
      // 设置动效胶囊终点参数
      capAnimContent?.setBorderRadius(radius).setClipHeight(cardPositionWrapper.getCmpHeight())
        .setClipWidth(cardPositionWrapper.getCmpWidth());

      // 设置卡片终点参数
      cardState?.setClipWidth(cardPositionWrapper.getCmpWidth()).setClipHeight(cardPositionWrapper.getCmpHeight())
        .setTranX(MIN).setTranY(MIN).setBorderRadius(radius);
    });

    if (this.isMediaCenterAnim() && !isToggle) {
      cardState?.setAlpha(MAX);
      capAnimContent?.setAlpha(MIN);
    } else {
      animateTo(this.getSecondaryAnimParams(param.animScene), () => {
        cardState?.setAlpha(MAX);
        capAnimContent?.setAlpha(MIN);
      });
    }
  }

  private getConCapsulePositionFromRoot(): CmpPosWrapper {
    // 直接用内容胶囊 ，pad上只有一个通知场景旋转，内容胶囊不存在位置不会更新
    let rootPosition = this.capsuleAnimMgr.getRootViewPosition() as ComponentPosition;
    let tempPostion = ObjectCopyUtil.simpleClone(rootPosition);
    let marginTop = this.capsuleAnimMgr
      .getChildAnimStyle(CapsulePositionType.TYPE_SHADOW)?.getStyleValue(AnimStyleType.MARGIN_TOP) ?? 0;
    tempPostion.height = (tempPostion.height ?? 0) - marginTop;
    tempPostion.height = (tempPostion.height <= 0) ?
    ImmersiveCapsuleConstants.CAPSULE_HEIGHT : tempPostion.height;
    return CmpPosWrapper.wrapper(tempPostion);
  }


  private initCardToCapsuleAnim(param: ItemAnimParam, isToggle?: boolean): void {
    let capsuleRootState = this.capsuleAnimMgr.getRootAnimState();
    let capContent = this.capsuleAnimMgr.getChildAnimState(CapsulePositionType.TYPE_CONTENT);
    let cardState = isToggle ? this.cardAnimMgr
      .getChildAnimState(CardAnimType.CARD_TOGGLE_TYPE) : this.cardAnimMgr.getRootAnimState();
    let capsulePositionWrapper = this.getConCapsulePositionFromRoot();
    let cardPositionWrapper = CmpPosWrapper.wrapper(this.cardAnimMgr.getRootViewPosition());

    // 设置初始化状态
    let animScene: WAnimScene = { isAnimating: true, animScene: param.animScene };
    capsuleRootState.setAnimScene(animScene);
    ImmersiveTraceHelper.startAnimTrace(param.animScene);

    let tranY = capsulePositionWrapper.getCmpGlobalY() - cardPositionWrapper.getCmpGlobalY();
    let tranX = capsulePositionWrapper.getCmpCenterX() - cardPositionWrapper.getCmpCenterX();
    let radius = this.getCardAnimMgr().getRootAnimStyle().getValueDefault(AnimStyleType.RADIUS);

    // 内容胶囊初始化
    capContent?.setAnimScene(animScene).setClip(true)
      .setTranY(-tranY)
      .setTranX(-tranX)
      .setBorderRadius(radius)
      .setClipWidth(cardPositionWrapper.getCmpWidth())
      .setClipHeight(cardPositionWrapper.getCmpHeight())
      .setAlpha(MIN);

    // 动效卡片参数初始化
    cardState.setAnimScene(animScene)
      .setAlpha(MAX)
      .setWidth(cardPositionWrapper.getCmpWidth())
      .setHeight(cardPositionWrapper.getCmpHeight())
      .setClipWidth(cardPositionWrapper.getCmpWidth())
      .setClipHeight(cardPositionWrapper.getCmpHeight())
      .setBorderRadius(radius)
      .setZIndex(CARD_Z_INDEX);
    if (isToggle) {
      this.cardAnimMgr.getRootAnimState().setZIndex(CARD_Z_INDEX);
    }
  }

  private handleCardToCapsuleAnim(param: ItemAnimParam, callback?: () => void, isToggle?: boolean,
    oldArea?: Area): void {
    let capContent = this.capsuleAnimMgr.getChildAnimState(CapsulePositionType.TYPE_CONTENT);
    let cardState = isToggle ? this.cardAnimMgr
      .getChildAnimState(CardAnimType.CARD_TOGGLE_TYPE) : this.cardAnimMgr.getRootAnimState();
    let capsulePositionWrapper = this.getConCapsulePositionFromRoot();
    let cardPositionWrapper = CmpPosWrapper.wrapper(this.cardAnimMgr.getRootViewPosition());

    let tranY = capsulePositionWrapper.getCmpGlobalY() - cardPositionWrapper.getCmpGlobalY();
    let tranX = capsulePositionWrapper.getCmpCenterX() - cardPositionWrapper.getCmpCenterX();
    let radius = this.capsuleAnimMgr.getCapValidStyle(CapsulePositionType.TYPE_ANIM_CONTENT)
      .getValueDefault(AnimStyleType.RADIUS);

    // 动效完成，复位
    let animFinish = (): void => {
      callback?.();
      this.cardAnimMgr?.clearImmersiveCardAnimData();
      this.resetCapAnimState(param.animScene);
      this.clearAnimStateProperty(cardState, param.animScene);
      ImmersiveTraceHelper.endAnimTrace(param.animScene);
      this.cardAnimMgr.setRootViewArea(oldArea);
      if (isToggle) {
        this.cardAnimMgr.getRootAnimState().setZIndex();
      }
      log.showInfo('CardToCapsule end');
    };

    let key: string = util.generateRandomUUID();
    this.animStMgr.addAnimSceneFinish(param.animScene, { onAnimFinish: animFinish, key: key }); // 缓存动效
    animateTo(this.getMainAnimParams(param.animScene, 0, {
      onFinish: () => this.animStMgr.exeAnimSceneFinish(param.animScene, key)
    }), () => {
      // 胶囊内容动效终点参数
      capContent?.setClipWidth(capsulePositionWrapper.getCmpWidth()).setBorderRadius(radius)
        .setClipHeight(capsulePositionWrapper.getCmpHeight()).setTranY(MIN).setTranX(MIN);

      // 动效卡片终点参数
      cardState.setClipWidth(capsulePositionWrapper.getCmpWidth())
        .setClipHeight(capsulePositionWrapper.getCmpHeight())
        .setTranY(tranY)
        .setTranX(tranX)
        .setBorderRadius(radius);
    });

    let preParam: AnimateParam = {};
    if (!isToggle) {
      preParam.onFinish = () => {
        log.showInfo('handleCardToCapsuleAnim card alpha finish.')
        cardList.setShowData();
      }
    }

    if (this.isMediaCenterAnim() && !isToggle) {
      cardState.setAlpha(MIN);
      capContent?.setAlpha(MAX);
    } else {
      animateTo(this.getSecondaryAnimParams(param.animScene, preParam), () => {
        cardState.setAlpha(MIN);
        capContent?.setAlpha(MAX);
      });
    }
  }

  /**
   * 动效结束回调处理
   */
  private onCommonAnimFinish = (param: ItemAnimParam): void => {
    // 动效结束，胶囊复位
    this.resetCapAnimState(param?.animScene);
    // 最后条目动效结束
    if (param?.isLastItem) {
      this.clearAnimStateProperty(this.listAnimMgr.getRootAnimState(), param.animScene);
      if (!ArrayUtils.isEmpty(param.itemList)) {
        // 回收条目动效参数
        param.isAnimInit = false;
        param.tarItemAction = this.finishList2CapsuleItem;
        this.forList2CapsuleItem(param);
      }
      if (param.animScene) {
        ImmersiveTraceHelper.endAnimTrace(param.animScene);
      }
      param?.callback?.(); // 动效结束回调
    }
  };

  /**
   * 列表过渡胶囊动效，遍历条目
   *
   * @param params 参数
   * @returns 是否有有效条目
   */
  private forList2CapsuleItem(params: ItemAnimParam): boolean {
    let isAnimInit = params.isAnimInit ?? false;
    let startIndex = this.listAnimMgr.getStartIndex();
    let endIndex = this.listAnimMgr.getEndIndex();
    if (!isAnimInit) { // 非动效初始化场景，使用条目标识集
      startIndex = ArrayUtils.isEmpty(params.itemList) ? BaseConstants.INVALID_INDEX : MIN;
      endIndex = ArrayUtils.getSize(params.itemList) - MAX;
    } else { // 初始化场景，收集条目标识
      params.itemList = [];
    }
    let hasValidItem = false;
    let capChain: CapTypeChain | undefined = this.capsuleAnimMgr.getDefaultCapChain();
    for (let i = startIndex; i <= endIndex; i++) {
      let itemParam: ItemAnimParam = params.itemList?.[i] ?? {
        isLastItem: i === endIndex,
        animScene: params.animScene, velocity: params.velocity
      };
      itemParam.hashcode = isAnimInit ? this.listAnimMgr.getItemHashcode(i) : itemParam?.hashcode;
      if (CommonUtils.isInvalid(itemParam.hashcode) ||
        (params !== itemParam && itemParam.hashcode === params.hashcode)) {
        continue;
      }
      hasValidItem = true;
      params.itemList?.push(itemParam);
      itemParam.mapCapsuleType = capChain?.getCapType() ?? CapsulePositionType.TYPE_NONE;
      params.tarItemAction?.(itemParam);
      capChain = capChain?.getNext();
    }

    if (params.excludeTarItemAction) {
      this.forExcludeTarItemItem(params, startIndex, endIndex);
    }

    return hasValidItem;
  }

  /**
   * 列表过渡胶囊动效，遍历非目标条目
   *
   * @param params 动效参数
   * @param startIndex 目标条目开始索引
   * @param endIndex 目标条目结束索引
   */
  private forExcludeTarItemItem(params: ItemAnimParam, startIndex: number, endIndex: number): void {
    let listSize = this.listAnimMgr.getListDataSize();
    for (let i = 0; i < listSize; i++) {
      if (i >= startIndex && i <= endIndex) {
        continue;
      }
      let itemParam: ItemAnimParam = {
        hashcode: this.listAnimMgr.getItemHashcode(i),
        animScene: params.animScene,
        velocity: params.velocity
      };
      params.itemList?.push(itemParam);
      params.excludeTarItemAction?.(itemParam);
    }
  }

  /**
   * 列表过渡胶囊动效，动效finish
   *
   * @param param 动效参数
   * @returns 动效finish
   */
  private getList2CapsuleFinish(param: ItemAnimParam): OnAnimFinish {
    let animFinish = async (): Promise<void> => {
      if (!this.animStMgr.hasAnimSceneFinish(param.animScene)) { // 动效已被打断finish
        return;
      }
      // 拦截finish执行
      if (interruptHelper.animListCardIt.hasInterrupt()) {
        await interruptHelper.animListCardIt.awaitInterrupt();
      }
      param.isAnimInit = false;
      param.isLastItem = true;
      param.onAnimFinish = this.onCommonAnimFinish;
      param.onAnimFinish?.(param);
      this.slClockAnimMgr.clearClockAnimState(param.animScene);
      this.animStMgr.setBlurFreezeState(false, param.animScene); // 放开模糊
      log.showInfo('ListToCapsule end');
    };
    this.animStMgr.addAnimSceneFinish(param.animScene, { onAnimFinish: animFinish }); // 缓存动效
    return () => this.animStMgr.exeAnimSceneFinish(param.animScene);
  }

  /**
   * 列表过渡胶囊动效，条目初始化
   */
  private initList2CapsuleFixItem = (param: ItemAnimParam): void => {
    let mapCapsuleType = param?.mapCapsuleType ?? CapsulePositionType.TYPE_NONE;
    let hashcode = param?.hashcode ?? '';
    let itemOriPos = CmpPosWrapper.wrapper(this.listAnimMgr.getChildViewPosition(hashcode));
    let itemPosWrap = this.listAnimMgr.transformItemPosition(hashcode);
    param.itemTarPos = itemPosWrap;
    let itemState = this.listAnimMgr.getChildAnimState(hashcode);
    let capPosWrap = CmpPosWrapper.wrapper(this.capsuleAnimMgr.getCapValidPos(mapCapsuleType));
    let capState = this.capsuleAnimMgr.getCapValidAnimSt(mapCapsuleType);
    itemState.setAnimScene({ isAnimating: true, animScene: param?.animScene });
    capState.setAnimScene({ isAnimating: true, animScene: param?.animScene });
    let itemWidth = itemPosWrap.getCmpWidth();
    let itemHeight = itemPosWrap.getCmpHeight();
    let itemCurScale = itemState.getScaleX() ?? MAX;
    let scaleWidth = itemWidth * itemCurScale;
    let scaleHeight = itemHeight * itemCurScale;
    let dY = (itemHeight - scaleHeight) / BaseConstants.DIVIDE;
    let itemRadius = this.listAnimMgr.getChildAnimStyle(hashcode).getValueDefault(AnimStyleType.RADIUS) * itemCurScale;
    itemState.setWidth(itemOriPos.getCmpWidth())
      .setHeight(itemOriPos.getCmpHeight())
      .setClipWidth(scaleWidth)
      .setScaleCenterY(this.listAnimMgr.getItemScaleCenterY(hashcode))
      .setClipHeight(scaleHeight)
      .setClipOffsetY(dY)
      .setBorderRadius(itemRadius)
      .setClip(true)
      .setAlignContent(Alignment.Top);
    let itemCurTranY = itemState.getTranY() ?? MIN;
    let diffTranX = capPosWrap.getCmpCenterX() - itemPosWrap.getCmpCenterX();
    let diffTranY = capPosWrap.getCmpGlobalY() - (itemPosWrap.getCmpGlobalY() + itemCurTranY);
    // 是否胶囊跟随动效
    let isMapCapsule = !this.capsuleAnimMgr.isCapsuleNone(mapCapsuleType);
    if (isMapCapsule) {
      capState?.setTranX(-diffTranX).setTranY(-diffTranY)
        .setClipOffsetY(dY)
        .setAlpha(MIN)
        .setClipWidth(scaleWidth)
        .setClipHeight(scaleHeight)
        .setClip(true)
        .setBorderRadius(itemRadius);
    }
  };
  /**
   * 列表过渡胶囊动效，非目标条目初始化
   */
  private initList2CapsuleFixExcludeItem = (param: ItemAnimParam): void => {
    let hashcode = param.hashcode;
    if (!hashcode) {
      log.showWarn('initList2CapsuleFixExcludeItem param.hashcode is empty')
      return;
    }
    let itemState = this.listAnimMgr.getChildAnimState(hashcode);
    itemState.setAnimScene({ animScene: param.animScene, isAnimating: true }).setAlpha(MIN);
  };
  /**
   * 列表过渡胶囊动效，设置条目属性最终值
   */
  private setList2CapsuleItemEndValue = (param: ItemAnimParam): void => {
    let mapCapsuleType = param?.mapCapsuleType ?? CapsulePositionType.TYPE_NONE;
    let hashcode = param?.hashcode ?? '';
    // 计算列表条目初始位置，标示动效开启
    let itemPosWrap = param.itemTarPos ?? this.listAnimMgr.transformItemPosition(hashcode);
    let itemState = this.listAnimMgr.getChildAnimState(hashcode);
    let capPosWrap = CmpPosWrapper.wrapper(this.capsuleAnimMgr.getCapValidPos(mapCapsuleType));
    let capState = this.capsuleAnimMgr.getCapValidAnimSt(mapCapsuleType);
    let capStyle = this.capsuleAnimMgr.getCapValidStyle(mapCapsuleType);
    let itemWidth = itemPosWrap.getCmpWidth();
    let itemHeight = itemPosWrap.getCmpHeight();
    let capWidth = capPosWrap.getCmpWidth();
    let capHeight = capPosWrap.getCmpHeight();
    let capRadius = capStyle.getValueDefault(AnimStyleType.RADIUS);
    let itemScale = itemWidth > MIN ? capWidth / itemWidth : MAX;
    let itemClipHeight = Math.min(capHeight, itemHeight * itemScale);
    let diffTranX = capPosWrap.getCmpCenterX() - itemPosWrap.getCmpCenterX();
    let diffTranY = capPosWrap.getCmpGlobalY() - itemPosWrap.getCmpGlobalY();
    itemState.setTranX(diffTranX)
      .setTranY(diffTranY)
      .setScaleX(itemScale)
      .setScaleY(itemScale)
      .setClipWidth(capWidth)
      .setClipHeight(itemClipHeight)
      .setBorderRadius(capRadius)
      .setClipOffsetY((itemHeight - itemClipHeight) / BaseConstants.DIVIDE);
    // 是否胶囊跟随动效
    let isMapCapsule = !this.capsuleAnimMgr.isCapsuleNone(mapCapsuleType);
    if (isMapCapsule) {
      capState?.setTranX(MIN).setTranY(MIN)
        .setClipOffsetY(MIN)
        .setBorderRadius(capRadius)
        .setClipWidth(capWidth)
        .setClipHeight(capHeight);
    }
  };
  /**
   * 列表过渡胶囊动效，透明度切换
   */
  private setList2CapsuleItemSecondary = (param: ItemAnimParam): void => {
    let mapCapsuleType = param?.mapCapsuleType ?? CapsulePositionType.TYPE_NONE;
    let hashcode = param?.hashcode ?? '';
    let itemState = this.listAnimMgr.getChildAnimState(hashcode);
    let capState = this.capsuleAnimMgr.getCapValidAnimSt(mapCapsuleType);
    let capStyle = this.capsuleAnimMgr.getCapValidStyle(mapCapsuleType);
    let isMapCapsule = !this.capsuleAnimMgr.isCapsuleNone(mapCapsuleType);
    itemState.setAlpha(MIN);
    if (isMapCapsule) {
      capState?.setAlpha(capStyle.getValueDefault(AnimStyleType.ALPHA));
    }
  };
  /**
   * 列表过渡胶囊动效，条目动效结束
   */
  private finishList2CapsuleItem = (param: ItemAnimParam): void => {
    if (!CommonUtils.isInvalid(param?.hashcode)) {
      let itemState = this.listAnimMgr.getChildAnimState(param?.hashcode!);
      this.clearAnimStateProperty(itemState, param?.animScene);
    }
  };
  /**
   * 列表过渡胶囊跟手复位动效，初始化条目
   */
  private initList2CapsuleBackItem = (param: ItemAnimParam): void => {
    let hashcode = param?.hashcode ?? '';
    let itemState = this.listAnimMgr.getChildAnimState(hashcode);
    itemState.setAnimScene({ isAnimating: true, animScene: param?.animScene });
  };
  /**
   * 列表过渡胶囊跟手复位动效，开启条目动效
   */
  private startList2CapsuleBackItem = (param: ItemAnimParam): void => {
    let hashcode = param?.hashcode ?? '';
    let itemState = this.listAnimMgr.getChildAnimState(hashcode);
    let itemPos = CmpPosWrapper.wrapper(this.listAnimMgr.getChildViewPosition(hashcode));
    itemState.setAnimScene({ isAnimating: true, animScene: param?.animScene })
      .setTranY(MIN)
      .setClipHeight(itemPos.getCmpHeight())
      .setClipWidth(itemPos.getCmpWidth())
      .setScaleX(MAX)
      .setScaleY(MAX);
  };

  /**
   * 胶囊过渡列表动效，初始化
   *
   * @param rootParam 动效参数收集
   * @returns true初始化成功
   */
  private initCapsule2ListFixAnim(rootParam: ItemAnimParam): boolean {
    rootParam.itemStartIndex = this.listAnimMgr.getStartIndex();
    rootParam.itemEndIndex = this.listAnimMgr.getEndIndex();
    let endCode = this.listAnimMgr.getItemHashcode(rootParam.itemEndIndex);
    if (rootParam.hashcode && rootParam.hashcode === endCode) { // 跳过动效的条目为最后一个，则last需要前移
      rootParam.itemEndIndex -= BaseConstants.MAX_VALUE;
    }
    if (rootParam.itemEndIndex <= BaseConstants.INVALID_INDEX) { // 无有效条目，不开启动效
      log.showInfo(`startCapsule2ListFixAnim invalid index: ${rootParam.hashcode}`);
      return false;
    }
    rootParam.itemList = [];
    let scene = rootParam.animScene;
    this.capsuleAnimMgr.setRootAnimating(true, scene);
    this.listAnimMgr.setRootAnimating(true, scene);
    ImmersiveTraceHelper.startAnimTrace(scene);
    return true;
  }

  /**
   * 胶囊过渡列表动效，处理单个条目动效
   *
   * @param rootParam 整体动效参数
   * @param itemKey 条目标识
   * @returns true动效正常启动
   */
  private handleCapsule2ListItemAnim(rootParam: ItemAnimParam, itemKey?: string): boolean {
    let index = rootParam.itemIndex ?? BaseConstants.INVALID_INDEX;
    let startIndex = rootParam.itemStartIndex ?? BaseConstants.INVALID_INDEX;
    let endIndex = rootParam.itemEndIndex ?? BaseConstants.INVALID_INDEX;
    rootParam.isLastItem = index === (endIndex + ITEM_CACHE_COUNT); // 循环终止标志
    let capsuleType = rootParam.mapCapsuleType ?? CapsulePositionType.TYPE_NONE;
    let itemParam: ItemAnimParam = {
      hashcode: itemKey,
      animScene: rootParam.animScene,
      itemIndex: index,
      velocity: rootParam.velocity,
      mapCapsuleType: capsuleType
    };
    itemParam.isFirstItem = index === startIndex;
    itemParam.isLastItem = index === endIndex;
    itemParam.animDelay = (index - startIndex) * ITEM_ANIM_DELAY + (rootParam.animDelay ?? 0);
    if (CommonUtils.isInvalid(itemKey) || rootParam.hashcode === itemKey) {
      log.showWarn(`startCapsule2ListFixAnim invalid item: ${itemKey}`);
      return false;
    }

    // 缓存动效列表
    rootParam.itemList?.push(itemParam);
    if (itemParam.isLastItem) {
      itemParam.onAnimFinish = this.onCommonAnimFinish;
      itemParam.callback = rootParam.callback;
      itemParam.itemList = rootParam.itemList;
    }
    this.initCapsule2ListFixItem(itemParam);
    this.startCapsule2ListFixItemAnim(itemParam);
    return true;
  }

  /**
   * 胶囊固定过渡列表动效，条目参数初始化
   *
   * @param param 动效参数
   */
  private initCapsule2ListFixItem(param: ItemAnimParam): void {
    let hashcode = param.hashcode ?? '';
    let mapCapsuleType = param.mapCapsuleType ?? CapsulePositionType.TYPE_NONE;
    let itemState = this.listAnimMgr.getChildAnimState(hashcode);
    let itemOriPos = CmpPosWrapper.wrapper(this.listAnimMgr.getChildViewPosition(hashcode));
    let itemPosWrap = this.listAnimMgr.transformItemPosition(hashcode);
    param.itemTarPos = itemPosWrap;
    let capPosWrap = CmpPosWrapper.wrapper(this.capsuleAnimMgr.getCapValidPos(mapCapsuleType));
    let capState = this.capsuleAnimMgr.getCapValidAnimSt(mapCapsuleType);
    itemState.setAnimScene({ isAnimating: true, animScene: param.animScene });
    let itemWidth = itemPosWrap.getCmpWidth();
    let itemHeight = itemPosWrap.getCmpHeight();
    let capWidth = capPosWrap.getCmpWidth();
    let capHeight = capPosWrap.getCmpHeight();
    let itemScale = itemWidth > MIN ? capWidth / itemWidth : MAX;
    let itemClipHeight = Math.min(capHeight, itemHeight * itemScale);
    let capStyle = this.capsuleAnimMgr.getCapValidStyle(mapCapsuleType);
    let capRadius = capStyle.getValueDefault(AnimStyleType.RADIUS);
    let capTranY = capStyle.getValueDefault(AnimStyleType.TRAN_Y);
    let diffTranX = capPosWrap.getCmpCenterX() - itemPosWrap.getCmpCenterX();
    let diffTranY = capPosWrap.getCmpGlobalY() - itemPosWrap.getCmpGlobalY();
    itemState.setWidth(itemOriPos.getCmpWidth())
      .setHeight(itemOriPos.getCmpHeight())
      .setClipWidth(capWidth)
      .setClipHeight(itemClipHeight)
      .setClipOffsetY((itemHeight - itemClipHeight) / BaseConstants.DIVIDE)
      .setTranX(diffTranX)
      .setTranY(diffTranY + capTranY)
      .setScaleX(itemScale)
      .setScaleY(itemScale)
      .setAlpha(MIN)
      .setBorderRadius(capRadius)
      .setClip(true)
      .setAlignContent(Alignment.Top);
    let isMapCapsule = !this.capsuleAnimMgr.isCapsuleNone(mapCapsuleType);
    if (isMapCapsule) { // 胶囊跟随动效
      capState?.setAnimScene({ isAnimating: true, animScene: param.animScene })
        .setClipWidth(capWidth)
        .setClipHeight(capHeight)
        .setBorderRadius(capRadius)
        .setClip(true)
        .setClipOffsetY(MIN);
    }
    if (param.isFirstItem && this.slClockAnimMgr.hasClockTranY()) { // 时钟元素跟随动效
      this.slClockAnimMgr.startClockAnimScene(param.animScene);
    }
  }

  /**
   * 胶囊固定过渡到列表动效，开启条目动效
   *
   * @param param 动效参数
   */
  private startCapsule2ListFixItemAnim(param: ItemAnimParam): void {
    let hashcode = param.hashcode ?? '';
    let mapCapsuleType = param.mapCapsuleType ?? CapsulePositionType.TYPE_NONE;
    let itemState = this.listAnimMgr.getChildAnimState(hashcode);
    let itemPos = param.itemTarPos ?? this.listAnimMgr.transformItemPosition(hashcode);
    let capPos = CmpPosWrapper.wrapper(this.capsuleAnimMgr.getCapValidPos(mapCapsuleType));
    let itemW = itemPos.getCmpWidth();
    let itemH = itemPos.getCmpHeight()
    let dX = capPos.getCmpCenterX() - itemPos.getCmpCenterX();
    let dY = capPos.getCmpGlobalY() - itemPos.getCmpGlobalY();
    let capState = this.capsuleAnimMgr.getCapValidAnimSt(mapCapsuleType);
    let isMapCapsule = !this.capsuleAnimMgr.isCapsuleNone(mapCapsuleType);
    let itemRadius = this.listAnimMgr.getChildAnimStyle(hashcode).getValueDefault(AnimStyleType.RADIUS);
    animateTo(this.getMainAnimParams(param.animScene, param.velocity,
      { delay: param.animDelay ?? 0, onFinish: this.getCapsule2ListItemFinish(param) }), () => {
      itemState.setTranX(MIN)
        .setTranY(MIN)
        .setClipWidth(itemW)
        .setClipHeight(itemH)
        .setScaleX(MAX)
        .setScaleY(MAX)
        .setClipOffsetY(MIN)
        .setBorderRadius(itemRadius);
      if (isMapCapsule) { // 有关联卡片的胶囊，则胶囊跟随动效
        capState?.setTranX(-dX).setTranY(-dY).setClipWidth(itemW).setClipHeight(itemH).setBorderRadius(itemRadius);
      }
      if (param.isFirstItem && this.slClockAnimMgr.hasClockTranY()) { // 时钟元素跟随
        this.slClockAnimMgr.endClockAnimState();
      }
    });
    animateTo(this.getSecondaryAnimParams(param.animScene, { delay: param.animDelay ?? 0 }), () => {
      itemState.setAlpha(MAX);
      if (isMapCapsule) {
        capState?.setAlpha(MIN);
      }
    });
  }

  /**
   * 胶囊过渡列表动效，条目动效finish
   *
   * @param param 动效参数
   * @returns 动效finish
   */
  private getCapsule2ListItemFinish(param: ItemAnimParam): OnAnimFinish | undefined {
    if (!param.isLastItem) { // 以最后一组动效为结束点
      return undefined;
    }
    let animFinish = (): void => {
      if (!this.animStMgr.hasAnimSceneFinish(param.animScene)) { // 动效已被打断finish
        return;
      }
      param.onAnimFinish?.(param); // 整体动效结束回调
      this.slClockAnimMgr.clearClockAnimState(param.animScene); // 时钟元素
      log.showInfo('CapsuleToList end');
    };
    this.animStMgr.addAnimSceneFinish(param.animScene, { onAnimFinish: animFinish }); // 缓存动效
    return () => this.animStMgr.exeAnimSceneFinish(param.animScene);
  }

  /**
   * 胶囊动效状态复位
   *
   * @param scene 动效场景
   */
  private resetCapAnimState(scene?: ImmersiveAnimScene): void {
    let capContent = CapsulePositionType.TYPE_CONTENT;
    let capAnim = CapsulePositionType.TYPE_ANIM_CONTENT;
    let capShadow = CapsulePositionType.TYPE_SHADOW;
    this.clearAnimStateProperty(this.capsuleAnimMgr.getRootAnimState(), scene);
    this.clearAnimStateProperty(this.capsuleAnimMgr.getChildAnimState(capContent), scene);
    this.clearAnimStateProperty(this.capsuleAnimMgr.getChildAnimState(capAnim), scene);
    this.clearAnimStateProperty(this.capsuleAnimMgr.getChildAnimState(capShadow), scene, true);
  }

  /**
   * 动效结束，清除动效参数
   *
   * @param state 动效状态
   * @param scene 动效场景
   * @param isForce 是否强制清除
   */
  private clearAnimStateProperty(state?: WidgetAnimState, scene?: ImmersiveAnimScene, isForce: boolean = false): void {
    if (!state) {
      return;
    }
    if (state.isSceneAnimating(scene) || isForce) {
      let anim: WAnimScene = { isAnimating: false, animScene: scene };
      state.setAnimScene(anim)
        .setClipOffsetX()
        .setClipOffsetY()
        .setClipWidth()
        .setClipHeight()
        .setWidth()
        .setHeight()
        .setTranX()
        .setTranY()
        .setScaleX()
        .setScaleY()
        .setScaleCenterY()
        .setAlpha()
        .setZIndex()
        .setBlur()
        .setMarginT()
        .clearBorderRadius()
        .setClip()
        .setAlignContent()
        .setUseEffect();
      // 子组件状态清除
      let innerSt = state.getChildState(state.getStateId());
      innerSt?.setAnimScene(anim).setMarginT()
        .setClipWidth()
        .setClipHeight()
        .setClipOffsetX()
        .setClipOffsetY()
        .setScaleX()
        .setScaleY()
        .setClip()
        .setUseEffect()
        .setAlpha()
        .setBlur();
      // 条目模糊关闭状态清除
      this.listAnimMgr.updateDisableEffect(state.getStateId());
    }
  }

  /**
   * 获取对应场景主动效参数
   *
   * @param scene 动效场景
   * @param velocity 速度因子
   * @param preParam 预置参数
   * @returns 动效参数
   */
  private getMainAnimParams(scene?: ImmersiveAnimScene, velocity?: number, preParam?: AnimateParam): AnimateParam {
    let result: AnimateParam = CommonUtils.isInvalid(preParam) ? {} : preParam!;
    let springVel = velocity ?? 0;
    switch (scene) {
      // 胶囊固定过渡到列表
      case ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX:
      // 胶囊跟手恢复
      case ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK:
      // 列表固定过渡到胶囊
      case ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX:
      // 列表到卡片  卡片到列表
      case ImmersiveAnimScene.SCENE_LIST_TO_CARD:
      case ImmersiveAnimScene.SCENE_CARD_TO_LIST:
      // 列表跟手恢复
      case ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK:
      // 胶囊到卡片
      case ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD:
      // 胶囊到卡片
      case ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE:
        result.curve = curves.interpolatingSpring(springVel, 1, 228, 24.5);
        return result;
      default:
        return result;
    }
  }

  /**
   * 获取对应场景辅动效参数
   *
   * @param scene 动效场景
   * @param preParam 预置参数
   * @returns 动效参数
   */
  private getSecondaryAnimParams(scene?: ImmersiveAnimScene, preParam?: AnimateParam): AnimateParam {
    let result: AnimateParam = CommonUtils.isInvalid(preParam) ? {} : preParam!;
    switch (scene) {
      // 胶囊固定过渡到列表
      case ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX:
      // 列表固定过渡到胶囊
      case ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX:
        result.duration = 100;
        result.curve = Curve.Linear;
        return result;
      case ImmersiveAnimScene.SCENE_LIST_TO_CARD:
      case ImmersiveAnimScene.SCENE_CARD_TO_LIST:
      case ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD:
      case ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE:
        result.duration = ALPHA_TIME;
        result.curve = curves.cubicBezierCurve(0.4, 0, 0.4, 1);
        return result;
      default:
        return result;
    }
  }

  /**
   * 播控一镜到底场景, 增加图片共享元素动效，去除大卡alpha动效
   *
   * @returns 是否为指定场景
   */
  private isMediaCenterAnim(): boolean {
    return this.cardAnimMgr.isMediaCenterAnim();
  }
}