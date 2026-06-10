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
import { ImmersiveAnimKey, ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';
import { ImmersiveAnimInfo } from '../../model/data/anim/ImmersiveAnimInfo';
import { AnimStyleType, ImmersiveAnimStyle } from '../../model/data/anim/ImmersiveAnimStyle';
import { curves } from '@kit.ArkUI';
import {
  slWallpaperMgr,
  SLWallpaperType,
  SLWallpaperVisibleScene,
  WBaseProperty
} from '@ohos/screenlockcommon';
import { BaseState, SlStateBaseMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ComponentPosition, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { SysTypeCode } from '@ohos/systemuicommon';
import { ImmersiveCardList } from '../viewdata/ImmersiveCardList';
import { ImmersiveAnimParam } from '../../common/anim/ImmersiveAnimParam';
import { CardAnimType } from '../../common/ImmersiveConstants';
import { ImmersiveCardConst } from '../../common/constants/ImmersiveCardConst';
import { ImmersiveTraceHelper } from '../../common/helper/ImmersiveTraceHelper';
import {
  immeLiveStateShareMgr
} from '@ohos/screenlockcommon/Index';
import { CardUpdateStratagemEnum } from '../ImmersiveCardVm';
import { immersiveStateMgr } from '../../common/manager/ImmersiveStateManager';
import { AnimationController } from '@ohos/mediacontrolcomponent/src/main/ets/default/Controller/AnimationController';
import { sharedData } from '@ohos/systemuicommon/Index';

/**
 * 沉浸锁屏卡片动效管理
 */
export class ImmersiveCardAnimManager {
  /**
   * 卡片根布局动效映射
   */
  private rootAnimInfo: ImmersiveAnimInfo = new ImmersiveAnimInfo(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT,
    new ImmersiveAnimStyle().bindStyle(AnimStyleType.RADIUS, ImmersiveCardConst.CARD_RADIUS));

  private animParamMap: Map<string, AnimateParam> = new Map();

  /**
   * 沉浸锁屏列表数据
   */
  private immersiveCardData?: ImmersiveCardList;

  constructor() {
    this.initAnimParamMap();
    this.initChildAnimInfo();
    immeLiveStateShareMgr.setCardRootAnimState(this.rootAnimInfo.getWidgetAnimState());
  }

  initChildAnimInfo(): void {
    if (SlStateBaseMgr.isV2Enable()) {
      return;
    }
    CARD_ANIM_TYPES.forEach((type) => {
      let childInfo: ImmersiveAnimInfo = new ImmersiveAnimInfo(type);
      childInfo.getWidgetAnimState().addChildState(BaseState.wrap(WidgetAnimState, type));
      this.rootAnimInfo.addChildAnimInfo(childInfo);
    });
    let rootName = this.getRootAnimState().getStateId();
    this.getRootAnimState().addChildState(BaseState.wrap(WidgetAnimState, rootName));
    // 同步动效管理器到播控
    AnimationController.setImmLiveCardAnim(this.getChildAnimState(CardAnimType.CARD_LIVE_CONTENT_TYPE));
  }

  initAnimParamMap(): void {
    let delAnimParam = {
      duration: 400,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
    } as AnimateParam;
    this.animParamMap.set(ImmersiveAnimScene.SCENE_CARD_DELETE, delAnimParam);

    let opacityAnimParam = {
      duration: 150,
      delay: 50,
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1)
    } as AnimateParam;
    this.animParamMap.set(CardAnimParamType.IMMERSIVE_CARD_OPACITY, opacityAnimParam);
  }

  doDeleteCardAnim(callback?: () => void, isOtherTheme?: boolean) {
    let rootState = this.getRootAnimState()
      .setAnimScene({ isAnimating: true, animScene: ImmersiveAnimScene.SCENE_CARD_DELETE })
      .setTransition(TransitionEffect.scale({ x: 0.85, y: 0.85 }));
    //卡片消失
    let animPram: AnimateParam = this.animParamMap.get(ImmersiveAnimScene.SCENE_CARD_DELETE) as AnimateParam;
    animPram.onFinish = ():void => {
      ImmersiveTraceHelper.endAnimTrace(ImmersiveAnimScene.SCENE_CARD_DELETE);
      callback?.();
      this.getRootAnimState().setAnimScene({ isAnimating: false, animScene: ImmersiveAnimScene.SCENE_CARD_DELETE })
        .setBlur().setLinearBlur().setAlpha().setTransition().setScaleX().setScaleY();
    }
    if (!isOtherTheme) {
      slWallpaperMgr.exitSlWallpaperScene(SLWallpaperType.TYPE_IMMERSIVE_STYLE,
        SLWallpaperVisibleScene.SCENE_IMMERSIVE_CARD);
    }

    ImmersiveTraceHelper.startAnimTrace(ImmersiveAnimScene.SCENE_CARD_DELETE);
    animateTo(
      this.animParamMap.get(ImmersiveAnimScene.SCENE_CARD_DELETE),
      () => {
        rootState.setScaleX(0.85).setScaleY(0.85);
      }
    )
    // 透明度变化
    animateTo(
      this.animParamMap.get(CardAnimParamType.IMMERSIVE_CARD_OPACITY),
      () => {
        immersiveStateMgr.exitImmersiveState(true);
        rootState.setAlpha(0);
      }
    )
  }

  doUpdateCardAnim(beforeAnimCall?: () => void, afterUpdateFinishCall?: () => void,
    beforeUpdateFinishCall?: () => void, stratagem: CardUpdateStratagemEnum = 0) {
    beforeAnimCall?.();
    let beforeUpdateParam = (CARD_ANIM_PARAM_MAP.get(
      CardAnimParamType.BEFORE_IMMERSIVE_CARD_UPDATE) as ImmersiveAnimParam).clone();
    this.dealAnimParams(stratagem, beforeUpdateParam);
    let beforeUpdateAnimState = this.getRootAnimState();

    let afterUpdateParam = CARD_ANIM_PARAM_MAP.get(CardAnimParamType.AFTER_IMMERSIVE_CARD_UPDATE) as ImmersiveAnimParam;
    let afterUpdateAnimState = this.getChildAnimState(CardAnimType.CARD_UPDATE_TYPE);

    afterUpdateParam.animFinish(() => {
      afterUpdateFinishCall?.()
    })
    beforeUpdateParam.animFinish(() => {
      ImmersiveTraceHelper.endAnimTrace(ImmersiveAnimScene.SCENE_CARD_UPDATE);
      beforeUpdateParam.setStateToStart(beforeUpdateAnimState);
      this.getRootAnimState().setAnimScene({ isAnimating: false, animScene: ImmersiveAnimScene.SCENE_CARD_UPDATE });
      beforeUpdateFinishCall?.();
      afterUpdateAnimState.setAnimScene({ isAnimating: false, animScene: ImmersiveAnimScene.SCENE_CARD_UPDATE });
    })

    ImmersiveTraceHelper.startAnimTrace(ImmersiveAnimScene.SCENE_CARD_UPDATE);
    animateTo(beforeUpdateParam, () => {
      beforeUpdateParam.setStateToEnd(beforeUpdateAnimState);
    })

    animateTo(afterUpdateParam, () => {
      afterUpdateParam.setStateToEnd(afterUpdateAnimState);
    })
  }

  /**
   * 设置沉浸锁屏列表数据
   *
   * @param list 列表数据
   */
  setImmersiveCardData(animShowData: ImmersiveCardList): void {
    this.immersiveCardData = animShowData;
  }

  getImmersiveCardData(): ImmersiveCardList | undefined {
    return this.immersiveCardData;
  }

  /**
   * 播控一镜到底场景, 增加图片共享元素动效，去除大卡alpha动效
   *
   * @returns 是否为指定场景
   */
  isMediaCenterAnim(): boolean {
    return this.getImmersiveCardData()?.showData?.cardData?.liveView?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER;
  }

  /**
   * 填充沉浸卡片动效数据
   */
  fillImmersiveCardAnimData(): void {
    if (this.immersiveCardData) {
      this.immersiveCardData.setAnimData(this.immersiveCardData.showData);
    }
  }

  /**
   * 清除沉浸卡片动效数据
   */
  clearImmersiveCardAnimData(): void {
    if (this.immersiveCardData) {
      this.immersiveCardData.setAnimData();
    }
  }

  /**
   * 获取根组件动效UI样式
   *
   * @returns UI样式
   */
  getRootAnimStyle(): ImmersiveAnimStyle {
    return this.rootAnimInfo.getComponentAnimStyle();
  }

  /**
   * 设置根组件动效UI样式对应值
   *
   * @param type 样式类型
   * @param value 值
   */
  setRootStyleValue(type: AnimStyleType, value?: number): void {
    this.getRootAnimStyle()?.bindStyle(type, value);
  }

  /**
   * 获取根组件动效状态
   *
   * @returns 动效状态
   */
  getRootAnimState(): WidgetAnimState {
    return this.rootAnimInfo.getWidgetAnimState();
  }


  /**
   * 设置根组件显示位置
   *
   * @param area 显示位置
   */
  setRootViewArea(area?: Area): void {
    this.rootAnimInfo.setComponentArea(area);
  }

  /**
   * 设置根组件显示位置
   *
   * @param area 显示位置
   */
  setChildViewArea(type: CardAnimType, area?: Area): void {
    this.rootAnimInfo.getChildAnimInfo(type)?.setComponentArea(area);
    if (type === CardAnimType.CARD_LIVE_CONTENT_TYPE) {
      immeLiveStateShareMgr.setCardContentPos(this.getChildViewPosition(type));
      sharedData.immersiveCardRect.update({
        x: immeLiveStateShareMgr.getCardContentPos()?.globalX ?? 0,
        y: immeLiveStateShareMgr.getCardContentPos()?.globalY ?? 0,
        width: immeLiveStateShareMgr.getCardContentPos()?.width ?? 0,
        height: immeLiveStateShareMgr.getCardContentPos()?.height ?? 0,
      });
    }
  }

  /**
   * 获取子组件显示位置
   *
   * @returns 显示位置
   */
  getChildViewPosition(type: CardAnimType): ComponentPosition | undefined {
    return this.rootAnimInfo.getChildAnimInfo(type)?.getComponentPosition();
  }

  /**
   * 获取根组件显示位置
   *
   * @returns 显示位置
   */
  getRootViewPosition(): ComponentPosition {
    return this.rootAnimInfo.getComponentPosition();
  }

  /**
   * 获得根组件显示区域
   *
   * @returns 显示区域
   */
  getRootViewArea(): Area | undefined {
    return this.rootAnimInfo.getComponentArea();
  }

  /**
   * 设置列表根组件动效中状态
   *
   * @param isAnimating 是否动效中
   * @param animScene 动效场景
   */
  setRootAnimating(isAnimating: boolean, animScene?: ImmersiveAnimScene): void {
    // 标示列表是否动效中
    this.getRootAnimState().setAnimScene({ isAnimating: isAnimating, animScene: animScene });
  }

  /**
   * 获取子组件状态
   *
   * @param type 卡片类型
   * @returns 卡片状态
   */
  getChildAnimState(type: CardAnimType): WidgetAnimState {
    return this.rootAnimInfo.getChildAnimInfo(type)?.getWidgetAnimState();
  }

  /**
   * 获取子组件状态
   *
   * @param type 卡片类型
   * @returns 卡片状态
   */
  getRootAnimInfo(): ImmersiveAnimInfo {
    return this.rootAnimInfo;
  }

  private dealAnimParams(stratagem: CardUpdateStratagemEnum, beforeParam: ImmersiveAnimParam): void {
    // 对小外屏沉浸大卡更新动效,调整透明度动效结束值
    if (stratagem === CardUpdateStratagemEnum.SMALL_SCREEN) {
      beforeParam.endValues = [0.9];
    }
  }
}

/**
 * 不同场景动效参数类型
 */
enum CardAnimParamType {
  /**
   * 沉浸卡片更新前
   */
  BEFORE_IMMERSIVE_CARD_UPDATE = 'before_immsersive_card_update',

  /**
   * 沉浸卡片更新后
   */
  AFTER_IMMERSIVE_CARD_UPDATE = 'after_immsersive_card_update',

  /**
   * 沉浸卡片透明
   */
  IMMERSIVE_CARD_OPACITY = 'immsersive_card_opacity'
}

const CARD_ANIM_PARAM_MAP: Map<string, ImmersiveAnimParam> = new Map([
// 更新场景旧的卡片淡出
  [CardAnimParamType.BEFORE_IMMERSIVE_CARD_UPDATE, new ImmersiveAnimParam()
    .animDelay(100)
    .animPros([WBaseProperty.ALPHA])
    .animStartValue([1])
    .animEndValue([0])
    .animDuration(150)
    .animCurve(curves.interpolatingSpring(0, 1, 228, 30))],
  // 更新场景新的卡片淡入
  [CardAnimParamType.AFTER_IMMERSIVE_CARD_UPDATE, new ImmersiveAnimParam()
    .animPros([WBaseProperty.ALPHA])
    .animStartValue([0])
    .animEndValue([1])
    .animDuration(350)
    .animCurve(curves.interpolatingSpring(0, 1, 228, 30))]
])

/**
 * 动效卡片类型
 */
const CARD_ANIM_TYPES: CardAnimType[] = [
  CardAnimType.CARD_UPDATE_TYPE,
  CardAnimType.CARD_TOGGLE_TYPE,
  CardAnimType.CARD_LIVE_IMAGE_TYPE,
  CardAnimType.CARD_LIVE_CONTENT_TYPE,
  CardAnimType.CARD_LIVE_BACK_BTN_TYPE,
];