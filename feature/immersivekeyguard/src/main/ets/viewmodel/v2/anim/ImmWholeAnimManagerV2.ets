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

import { curves } from '@kit.ArkUI';
import { ArrayUtils, CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { WAnimScene, WDefault } from '@ohos/screenlockcommon';
import { AnimEvent, CmpPosWrapper, WidgetAnimState, WidgetAnimStateV2 } from '@ohos/screenlockcommon/Index';
import { IImmersiveWholeAnimVm } from '../../../common/interface/IImmersiveWholeAnimVm';
import { ImmersiveAnimScene } from '../../../common/anim/ImmersiveAnimConstants';
import { HybridAnimParam } from '../../../common/constants/ImmComConst';
import { CapShowType, CAP_ALL_TYPE } from '../../../common/constants/ImmCapConst';
import { ImmListConst } from '../../../common/constants/ImmListConst';
import { ImmersiveTraceHelper } from '../../../common/helper/ImmersiveTraceHelper';
import { ImmAnimBaseMgrV2 } from './ImmAnimBaseManagerV2';

const TAG = 'ImmAnimMgrV2';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

const MIN = WDefault.MIN_VALUE;
const MAX = WDefault.MAX_VALUE;
const INVALID_INDEX = ImmListConst.INVALID_INDEX;

// 扩展条目索引最大值
const EXTEND_ITEM_SIZE = 6;

/**
 * 条目卡片/胶囊动效时参数传递
 */
interface ListCapAnimParam {
  /**
   * 条目唯一标示
   */
  groupKey?: string;

  /**
   * 动效场景
   */
  animScene?: ImmersiveAnimScene;

  /**
   * 当前条目映射的胶囊类型
   */
  mapCapType?: CapShowType;

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
   * 跟手速度
   */
  velocity?: number;

  /**
   * 是否为次要动效
   */
  isSecondaryAnim?: boolean;

  /**
   * 是否动效初始化场景
   */
  isAnimInit?: boolean;

  /**
   * 条目当前显示位置
   */
  itemTarPos?: CmpPosWrapper;

  /**
   * 所有参与动效条目标识集
   */
  itemList?: ListCapAnimParam[];

  /**
   * 原始参数
   */
  rootParam?: ListCapAnimParam;

  /**
   * 计算条目动效时延
   *
   * @param itemParam 条目参数
   * @returns 动效时延
   */
  calcAnimDelay?: (itemParam: ListCapAnimParam) => number;

  /**
   * 条目动效结束回调
   *
   * @param rootParam 含有动效结束回调的参数
   */
  onAnimFinish?: (rootParam: ListCapAnimParam) => void;

  /**
   * 可见条目目标动作
   *
   * @param itemParam 条目参数
   */
  tarItemAction?: (itemParam: ListCapAnimParam) => void;

  /**
   * 不可见条目目标动作
   *
   * @param itemParam 条目参数
   */
  excludeTarItemAction?: (itemParam: ListCapAnimParam) => void;

  /**
   * 动效结束回调
   */
  callback?: AnimEvent;
}

/**
 * 沉浸模块动效管理业务V2
 */
export class ImmWholeAnimMgrV2 extends ImmAnimBaseMgrV2 implements IImmersiveWholeAnimVm {
  // 列表过渡胶囊跟手回退动效，条目初始化
  private initList2CapBackItem = (itemParam: ListCapAnimParam): void => {
    let groupKey = itemParam?.groupKey ?? '';
    let itemState = this.getListAnim()?.getItemComAnimSt(groupKey);
    itemState?.setAnimScene({ isAnimating: true, animScene: itemParam?.animScene });
  };

  // 列表过渡胶囊跟手回退动效，条目动效终值设置
  private endList2CapBackItem = (param: ListCapAnimParam): void => {
    let groupKey = param?.groupKey ?? '';
    let itemState = this.getListAnim()?.getItemComAnimSt(groupKey);
    itemState?.setTranY(MIN).setScaleX(MAX).setScaleY(MAX);
  };

  // 列表过渡胶囊动效/胶囊过渡列表动效，动效整体结束条目状态复位
  private finishListCapItem = (itemParam: ListCapAnimParam): void => {
    if (!CommonUtils.isInvalid(itemParam?.groupKey)) {
      let groupKey = itemParam?.groupKey as string;
      let itemComState = this.getListAnim()?.getItemComAnimSt(groupKey);
      let itemInnerState = this.getListAnim()?.getItemInnerAnimSt(groupKey);
      this.clearAnimStPt(itemComState, itemParam?.animScene);
      this.clearAnimStPt(itemInnerState, itemParam?.animScene, true);
    }
  };

  /**
   * 开启列表过渡胶囊跟手回退动效
   *
   * @param vel 跟手速度
   */
  public startList2CapTouchBackAnim(vel: number = 0): void {
    let scene = ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK;
    ImmersiveTraceHelper.startAnimTrace(scene);
    let rootState = this.getListAnim()?.getRootAnimSt();
    rootState?.setAnimScene({ isAnimating: true, animScene: scene });
    this.getClockAnim()?.startClockAnimScene(scene); // 时钟组件跟随
    let rootParam: ListCapAnimParam = { animScene: scene, velocity: vel };
    rootParam.isAnimInit = true;
    rootParam.tarItemAction = this.initList2CapBackItem;
    this.forListCapItem(rootParam); // 初始化
    let animFinish = (): void => {
      ImmersiveTraceHelper.endAnimTrace(scene);
      rootParam.isAnimInit = false;
      rootParam.tarItemAction = this.finishListCapItem;
      this.forListCapItem(rootParam);
      this.clearAnimStPt(rootState, scene);
      this.getClockAnim()?.clearClockAnimState(scene);
    };
    rootParam.isAnimInit = false;
    rootParam.tarItemAction = this.endList2CapBackItem;
    this.getAnimExeMgr().animateToImmediately({
      mainScene: scene,
      oriParam: this.getMainAnimParams(scene, vel, { onFinish: animFinish }),
      oriEvent: () => {
        this.forListCapItem(rootParam);
        this.getClockAnim()?.endClockAnimState(); // 时钟组件跟随
      }
    });
  }

  /**
   * 开启胶囊过渡列表跟手回退动效
   *
   * @param vel 跟手速度
   */
  public startCap2ListTouchBackAnim(vel: number = 0): void {
    let scene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK;
    ImmersiveTraceHelper.startAnimTrace(scene);
    let capRootSt = this.getCapAnim()?.getRootAnimSt();
    capRootSt?.setAnimScene({ isAnimating: true, animScene: scene });
    this.getClockAnim()?.startClockAnimScene(scene); // 时钟跟随
    let contentState = this.getCapAnim()?.getItemComAnimSt(CapShowType.CAP_CONTENT);
    let shadowState = this.getCapAnim()?.getItemComAnimSt(CapShowType.CAP_SHADOW);
    contentState?.setAnimScene({ isAnimating: true, animScene: scene });
    shadowState?.setAnimScene({ isAnimating: true, animScene: scene });
    let animFinish = (): void => {
      ImmersiveTraceHelper.endAnimTrace(scene);
      this.getClockAnim()?.clearClockAnimState(scene);
      this.resetCapAnimSt(scene);
    };
    this.getAnimExeMgr().animateTo({
      mainScene: scene,
      oriParam: this.getMainAnimParams(scene, vel, { onFinish: animFinish }),
      oriEvent: () => {
        contentState?.setTranY(MIN);
        shadowState?.setTranY(MIN);
        this.getClockAnim()?.endClockAnimState();
      }
    });
  }

  /**
   * 开启联合动效
   *
   * @param param 动效参数
   */
  public startHybridAnim(param: HybridAnimParam): void {
    let animScene = param?.animScene;
    let hybridAnim = this.getVmInjector()?.getImmHybridAnimFactory()?.createImmAnim(animScene);
    if (!hybridAnim) {
      log.showWarn(TAG, `startHybridAnim no anim: ${animScene}`);
      return;
    }
    // 加入扩展参数
    hybridAnim.setHybridAnimParam(param);
    // 提前打断动效
    hybridAnim.interruptAnim();
    // 开启动效
    hybridAnim.onHybridAnim();
    log.showInfo(TAG, `startHybridAnim anim scene: ${animScene}`);
  }

  /**
   * 列表胶囊相互过渡动效，遍历条目
   *
   * @param rootParams 动效参数
   * @returns 是否有有效条目
   */
  private forListCapItem(rootParams: ListCapAnimParam): boolean {
    let isAnimInit = rootParams.isAnimInit ?? false;
    let startIndex = this.getListAnim()?.getItemStartIndex() ?? INVALID_INDEX;
    let endIndex = this.getListAnim()?.getItemEndIndex() ?? INVALID_INDEX;
    if (!isAnimInit) { // 非动效初始化场景，使用缓存条目标识集
      startIndex = ArrayUtils.isEmpty(rootParams.itemList) ? INVALID_INDEX : MIN;
      endIndex = ArrayUtils.getSize(rootParams.itemList) - MAX;
    } else { // 动效初始化场景，收集缓存条目标识
      rootParams.itemList = [];
    }
    if (startIndex === endIndex && rootParams.groupKey) { // 可见条目只有一个，并且存在跳过条目，则判断有效性
      let tarParam = rootParams.itemList?.[startIndex]; // 非初始化场景目标参数
      let tarGroupKey = isAnimInit ? this.getListAnim()?.getItemGroupKey(startIndex) :
        (rootParams === tarParam ? undefined : tarParam?.groupKey);
      if (tarGroupKey === rootParams.groupKey) { // 唯一可见条目被跳过，则标示无动效条目
        return false;
      }
    }
    rootParams.itemStartIndex = startIndex; // 记录起始索引
    rootParams.itemEndIndex = endIndex;
    let forStartIndex = startIndex;
    let forEndIndex = endIndex;
    if (rootParams.excludeTarItemAction) { // 遍历索引范围，默认可见范围，存在非可见条目action时，可左右扩展最大EXTEND_ITEM_SIZE个
      forStartIndex = Math.max(0, startIndex - EXTEND_ITEM_SIZE);
      const maxIndex = (this.getListAnim()?.getListDataSize() ?? MIN) - MAX;
      forEndIndex = Math.min(maxIndex, endIndex + EXTEND_ITEM_SIZE);
    }
    let capChain = this.getCapAnim()?.getDefaultCapChain();
    for (let i = forStartIndex; i <= forEndIndex; i++) {
      let itemParam: ListCapAnimParam = rootParams.itemList?.[i] ?? { velocity: rootParams.velocity,
        rootParam: rootParams, isFirstItem: i === startIndex, isLastItem: i === endIndex,
        animScene: rootParams.animScene, itemIndex: i };
      itemParam.groupKey = isAnimInit ? this.getListAnim()?.getItemGroupKey(i) : itemParam?.groupKey;
      if (CommonUtils.isInvalid(itemParam.groupKey) ||
        (rootParams !== itemParam && itemParam.groupKey === rootParams.groupKey)) { // 跳过动效
        continue;
      }
      itemParam.animDelay = rootParams.calcAnimDelay?.(itemParam); // 计算条目动效时延
      rootParams.itemList?.push(itemParam); // 存在收集器，收集参与动效条目
      if (i < startIndex || i > endIndex) { // 非可见条目范围
        rootParams.excludeTarItemAction?.(itemParam);
        continue;
      }
      // 胶囊类型匹配
      capChain = this.getCapAnim()?.getValidCapChain(capChain);
      itemParam.mapCapType = capChain?.getCapType() ?? CapShowType.CAP_NONE;
      rootParams.tarItemAction?.(itemParam);
      capChain = capChain?.getNext();
    }
    return true;
  }

  /**
   * 胶囊动效状态复位
   *
   * @param scene 动效场景
   */
  private resetCapAnimSt(scene?: ImmersiveAnimScene): void {
    this.clearAnimStPt(this.getCapAnim()?.getRootAnimSt(), scene);
    CAP_ALL_TYPE.forEach((capType) => {
      this.clearAnimStPt(this.getCapAnim()?.getItemComAnimSt(capType), scene, true);
    });
  }

  /**
   * 动效结束，清除动效参数
   *
   * @param state 动效状态
   * @param scene 动效场景
   * @param isForce 是否强制清除
   */
  private clearAnimStPt(state?: WidgetAnimState | WidgetAnimStateV2, scene?: ImmersiveAnimScene,
    isForce: boolean = false): void {
    if (!state) {
      return;
    }
    if (state.isSceneAnimating(scene) || isForce) {
      let anim: WAnimScene = { isAnimating: false, animScene: scene };
      state.setAnimScene(anim)
        .setClipOffsetX().setClipOffsetY()
        .setClipWidth().setClipHeight()
        .setWidth().setHeight()
        .setTranX().setTranY()
        .setScaleX().setScaleY()
        .setScaleCenterY().setAlpha()
        .setZIndex().setBlur()
        .setMarginT().clearBorderRadius()
        .setClip().setAlignContent()
        .setUseEffect();
    } else {
      log.showWarn(TAG, `clearAnimStPt error: ${scene}, ${state.getStateId()}`);
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
}