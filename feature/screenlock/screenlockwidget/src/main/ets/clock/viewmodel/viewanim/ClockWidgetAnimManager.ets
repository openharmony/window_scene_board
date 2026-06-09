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

import { clockLayoutParam, ElementConf } from '../../common/ClockLayoutParam';
import { ClockAnimData } from '../../model/data/ClockAnimData';
import curves from '@ohos.curves';
import { AnimationStateListener, CommonAnimationUtil } from '../../../common/utils/AnimationUtil';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { BatteryPosition, ElementConfIndex } from '../../common/ClockConstants';
import { ClockStaticData } from '../../model/data/ClockStaticData';
import { ClockBindData } from '../../model/data/ClockBindData';
import { NotificationState, NotificationStateManager } from '@ohos/screenlockcommon';
import {
  OnClockAnimInterruptListener
} from '@ohos/screenlockcommon/src/main/ets/notification/NotificationStateManager';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { IHook } from '../../../common/adapter/IHook';
import { ClockHookType, UseScene } from '../../../common/adapter/Constans';
import { slStateHelper } from '../../../common/utils/SlStateHelper';
import { ClockAdapterFactory } from '../../adapter/ClockAdapter';
import { ClockLayout } from '../../../common/WidgetParam';
import { ClockLayoutModifier } from '../../common/ClockLayoutModifier';

const TAG = 'ClockWidgetAnimManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 动效曲线类型
 */
export enum AnimParamType {
  MAIN_SPRING = 1, // 主动效弹簧曲线
  SECONDARY_CUBIC_BEZIER, // 次动效贝塞尔曲线
  DESKTOP_AOD_SPRING, // 桌面和AOD之间主动效弹簧曲线

  /**
   * 三方主题进入沉浸态主动效
   */
  OTHER_THEME_INTO_IMMERSIVE,

  /**
   * 三方主题进入沉浸态透明度动效
   */
  OTHER_THEME_INTO_IMMERSIVE_ALPHA,

  /**
   * 三方主题退出沉浸态主动效
   */
  OTHER_THEME_EXIT_IMMERSIVE,

  /**
   * 三方主题退出沉浸态透明度动效
   */
  OTHER_THEME_EXIT_IMMERSIVE_ALPHA
}

/**
 * 动效场景
 */
export enum AnimScene {
  SCENE_MAIN_COLLAPSE = 'main_spring_collapse', // 主动效收起场景
  SCENE_MAIN_EXPAND = 'main_spring_expand', // 主动效展开场景
  SCENE_SEP_ALPHA_COLLAPSE = 'separator_alpha_collapse', // 分隔符透明度收起场景
  SCENE_SEP_ALPHA_EXPAND = 'separator_alpha_expand', // 分隔符透明度展开场景

  /**
   * 三方主题进入沉浸态
   */
  SCENE_INTO_IMMERSIVE = 'scene_into_immersive',

  /**
   * 三方主题退出沉浸态
   */
  SCENE_EXIT_IMMERSIVE = 'scene_exit_immersive',
  /**
   * 进入局部AOD
   */
  SCENE_INTO_PART_AOD = 'scene_into_part_aod',
  /**
   * 退出局部AOD
   */
  SCENE_EXIT_PART_AOD = 'scene_exit_part_aod',
}

/**
 * 动效准备工作参数
 */
export interface AnimPrepareParam {
  mainAnimScene: AnimScene; // 主动效场景
  sepAlphaScene: AnimScene; // 分隔符透明度动效场景
  isTimeSeparate: boolean; // 小时分钟是否分散类型
  isPreSeparateShow: boolean; // 切换状态前分割符是否显示
  isCurSeparateShow: boolean; // 切换状态后分割符是否显示
  isPreSeparateLine: boolean; // 切换状态前是否为线分隔符
  isCurSeparateLine: boolean; // 切换状态后是否为线分隔符
  isPreLargeDate: boolean; // 切换状态前是否大日期样式
  isCurLargeDate: boolean; // 切换状态后是否大日期样式
  animListener?: AnimationStateListener; // 动效监听
  isPowerOff?: boolean; // 是否为灭屏动效
  fontDaley?: number; // 字体动画延时
  elemConfig?: ElementConf[]; // 动画结束后目标状态
}

export const ANIM_MIN_VALUE = 0; // 最小值
export const ANIM_MAX_VALUE = 1; // 最大值
export const TIME_SPRING_DELAY = 80; // 时钟分散场景动效时延
export const SEPARATOR_ALPHA_DELAY = 100; // 分隔符透明度动效时延
export const AOD_TO_DESKTOP_SEPARATOR_ALPHA_DELAY = 250; // AOD到桌面分隔符透明度动效时延
export const SEPARATOR_ALPHA_DURATION = 150; // 分隔符透明度动效时长
export const DESKTOP_TO_AOD_TIME_SPRING_DELAY = 100; // 桌面到AOD时钟分散场景动效时延
export const DESKTOP_AND_AOD_ANI_DELAY = 100; // 桌面和AOD间时钟动效时延
export const TIME_FIRST_LINE: number[] = [ElementConfIndex.HOUR_0, ElementConfIndex.HOUR_1]; // 时钟第一行元素
export const OTHER_LINE: number[] = [ // 其他行元素
  ElementConfIndex.SEPARATOR, ElementConfIndex.MINUTE_0,
  ElementConfIndex.MINUTE_1, ElementConfIndex.DATE,
  ElementConfIndex.WEEK, ElementConfIndex.LUNAR,
  ElementConfIndex.SIGN
];
const IMMERSIVE_CLOCK_SCALE = 1.15;
const DEFAULT_VALUE = 1;
const IMMERSIVE_CLOCK_BLUR = 50;
const IMMERSIVE_CLOCK_ALPHA_DURATION = 200

/**
 * 时钟动效入参
 */
export interface ClockAnimParam {
  isAnimToExpand: boolean; // 是否展开动效场景
  animListener?: AnimationStateListener; // 动效监听
}

/**
 * 时钟组件动效管理
 */
export class ClockWidgetAnimManager implements IHook {
  protected clockAnimData: ClockAnimData = new ClockAnimData(); // 时钟动效数据
  protected animSceneListener: Map<AnimScene, AnimationStateListener> = new Map(); // 动效finish监听缓存
  private ntfState: NotificationState = NotificationStateManager.notificationState; // 沉浸通知状态
  protected clockStaticState: ClockStaticData = new ClockStaticData(); // 时钟静态状态
  protected clockBindState: ClockBindData = new ClockBindData(); // 时钟动态状态
  // 时钟字号、位置调节器
  protected clockLayoutModifier: ClockLayoutModifier;
  private slClockAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlClockAnimState();
  private onClockAnimInterruptListener: OnClockAnimInterruptListener = (): void => { // 动效打断回调
    this.interceptAnimScene(AnimScene.SCENE_MAIN_COLLAPSE); // 打断已有动效
    this.interceptAnimScene(AnimScene.SCENE_MAIN_EXPAND);
    this.interceptAnimScene(AnimScene.SCENE_SEP_ALPHA_COLLAPSE);
    this.interceptAnimScene(AnimScene.SCENE_SEP_ALPHA_EXPAND);
  };

  /**
   * 构造
   *
   * @param staticState 静态状态
   * @param bindState 动态状态
   */
  constructor(staticState: ClockStaticData, bindState: ClockBindData, clockAnimData: ClockAnimData,
    clockLayoutModifier: ClockLayoutModifier, slClockAnimCtrl?: WidgetAnimState) {
    this.clockStaticState = staticState;
    this.clockBindState = bindState;
    this.clockAnimData = clockAnimData;
    this.clockLayoutModifier = clockLayoutModifier;
    this.slClockAnimCtrl = slClockAnimCtrl;
  }

  getHookType(): ClockHookType {
    return ClockHookType.CLOCK_ANIM_MANAGER;
  }

  /**
   * 时钟动效数据
   *
   * @returns 动效数据
   */
  public getClockAnimData(): ClockAnimData {
    return this.clockAnimData;
  }

  /**
   * 开启时钟元素收起、展开状态切换动效
   *
   * @param param 动效入参
   */
  public startCollapseStateChangeAnim(param: ClockAnimParam): void {
    if (!this.clockStaticState.getCurElementConf()) {
      log.showWarn(`startCollapseStateChangeAnim invalid param: ${param.isAnimToExpand}`)
      return;
    }
    NotificationStateManager.updateInterruptClockAnimListener(this.onClockAnimInterruptListener);
    this.interceptAnimScene(AnimScene.SCENE_MAIN_COLLAPSE); // 打断已有动效
    this.interceptAnimScene(AnimScene.SCENE_MAIN_EXPAND);
    let prepare = this.getAnimPrepareParam(param);
    if (this.ntfState.isDisableDelay) { // 强制关闭时延效果
      prepare.isTimeSeparate = false;
    }
    NotificationStateManager.updateClockAnimDelayState(prepare.isTimeSeparate); // 标识延时动效状态
    TraceUtil.startAnimTrace(DomainName.KG, prepare.mainAnimScene);
    prepare.animListener?.onAnimationStart?.(); // 动效开启回调
    this.startSeparatorAlphaAnim(prepare); // 分隔符alpha动效
    this.startAllElementAnim(prepare); // 全元素统一过渡动效
  }

  /**
   * 开启全元素整体过渡场景动效
   *
   * @param prepare 预备参数
   */
  private startAllElementAnim(prepare: AnimPrepareParam): void {
    this.initMainSpringAnim(prepare); // 初始化，开启元素共享
    if (prepare.isTimeSeparate) { // 离散小时、分钟类型
      let isCollapse = this.isAnimCollapse(prepare);
      let clockType = ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getDataManager()
        .getSlClockBindState().getClockLayout();
      let firstLineDelay = isCollapse ? ANIM_MIN_VALUE : TIME_SPRING_DELAY; // 第一行展开时delay
      let otherDelay = isCollapse ? TIME_SPRING_DELAY : ANIM_MIN_VALUE; // 其他行收起时delay
      if (clockType >= 200) {
        // 艺术签名样式，不做delay
        firstLineDelay = 0;
        otherDelay = 0;
      }
      CommonAnimationUtil.createAnimateToWithIntelligentFrame(
        this.getAnimCurve(AnimParamType.MAIN_SPRING, this.ntfState.velY),
        firstLineDelay, undefined, () => {
        if (this.isNotExeAnim(prepare)) {
          return;
        }
          this.updateElement(this.clockStaticState.getCurElementConf(), TIME_FIRST_LINE);
        }, isCollapse ? undefined : this.getMainSpringAnimListener(prepare));
      CommonAnimationUtil.createAnimateToWithIntelligentFrame(
        this.getAnimCurve(AnimParamType.MAIN_SPRING, this.ntfState.velY),
        otherDelay, undefined, () => {
        if (this.isNotExeAnim(prepare)) {
          return;
        }
          this.updateDateWeekLunarStyle(); // 元素共享动效
        });
      CommonAnimationUtil.createAnimateToWithIntelligentFrame(
        this.getAnimCurve(AnimParamType.MAIN_SPRING, this.ntfState.velY),
        otherDelay, undefined, () => {
        if (this.isNotExeAnim(prepare)) {
          return;
        }
          this.updateClockGridParam();
          this.updateElement(this.clockStaticState.getCurElementConf(), OTHER_LINE);
        }, isCollapse ? this.getMainSpringAnimListener(prepare) : undefined);
      return;
    }
    // 统一动效
    CommonAnimationUtil.createAnimateToWithIntelligentFrame(
      this.getAnimCurve(AnimParamType.MAIN_SPRING, this.ntfState.velY), 0, undefined,
      () => {
        if (this.isNotExeAnim(prepare)) {
          return;
        }
        this.updateDateWeekLunarStyle(); // 元素共享动效
      });
    CommonAnimationUtil.createAnimateToWithIntelligentFrame(
      this.getAnimCurve(AnimParamType.MAIN_SPRING, this.ntfState.velY), 0, undefined,
      () => {
        if (this.isNotExeAnim(prepare)) {
          return;
        }
        this.updateClockGridParam();
        this.updateElement(this.clockStaticState.getCurElementConf());
      }, this.getMainSpringAnimListener(prepare));
  }

  /**
   * 是否不执行动效
   * 动效执行前折展状态被修改，则不执行旧状态动效
   *
   * @param prepare 动效参数
   * @returns 是否不执行动效
   */
  private isNotExeAnim(prepare: AnimPrepareParam): boolean {
    return (prepare.mainAnimScene === AnimScene.SCENE_MAIN_EXPAND ?? false) !==
      ClockStaticData.sIsClockWidgetExpand;
  }

  /**
   * 开启分隔符透明度过渡动效
   *
   * @param prepare 预备参数
   */
  private startSeparatorAlphaAnim(prepare: AnimPrepareParam): void {
    if (!prepare.isPreSeparateShow && !prepare.isCurSeparateShow) { // 分割符始终不可见，不涉及动效
      return;
    }
    if (prepare.isPreSeparateShow && prepare.isCurSeparateShow &&
      prepare.isPreSeparateLine === prepare.isCurSeparateLine) { // 分割符可见且无切换，不涉及动效
      return;
    }
    this.interceptAnimScene(AnimScene.SCENE_SEP_ALPHA_COLLAPSE); // 打断已有alpha动效
    this.interceptAnimScene(AnimScene.SCENE_SEP_ALPHA_EXPAND);
    let lineEndAlpha = this.initLineAlphaAnim(prepare);
    let pointEndAlpha = this.initPointAlphaAnim(prepare);
    // 动效场景，收起动效延时启动
    let delay = this.isAnimCollapse(prepare) ? SEPARATOR_ALPHA_DELAY : ANIM_MIN_VALUE;
    CommonAnimationUtil.createAnimateToWithIntelligentFrame(
      this.getAnimCurve(AnimParamType.SECONDARY_CUBIC_BEZIER), delay,
      SEPARATOR_ALPHA_DURATION, () => {
      if (this.isNotExeAnim(prepare)) {
        return;
      }
        if (this.clockAnimData.lineSeparatorAnimating) {
          this.clockAnimData.setLineSeparatorAlpha(lineEndAlpha);
        }
        if (this.clockAnimData.pointSeparatorAnimating) {
          this.clockAnimData.setPointSeparatorAlpha(pointEndAlpha);
        }
      }, this.getSeparatorAlphaListener(prepare.sepAlphaScene));
  }

  /**
   * 主动效初始化
   *
   * @param prepare 预备参数
   */
  protected initMainSpringAnim(prepare: AnimPrepareParam): void {
    this.clockAnimData.setDateGeometryEnable(true)
      .setWeekGeometryEnable(true)
      .setLunarGeometryEnable(true);
    if (prepare.isPreLargeDate !== prepare.isCurLargeDate) { // 日期样式有变化，开启转场效果
      this.clockAnimData.setDateTransitionEnable(true);
    }
  }

  /**
   * 线分隔符透明度初始化
   *
   * @param prepare 预备参数
   * @returns 动效终值
   */
  private initLineAlphaAnim(prepare: AnimPrepareParam): number {
    if (prepare.isPreSeparateShow !== prepare.isCurSeparateShow) { // 可见性切换，直接alpha过渡
      if (prepare.isCurSeparateLine) { // 线分隔符动效生效
        let startAlpha = prepare.isCurSeparateShow ? ANIM_MIN_VALUE : ANIM_MAX_VALUE;
        let endAlpha = prepare.isCurSeparateShow ? ANIM_MAX_VALUE : ANIM_MIN_VALUE;
        this.clockAnimData.setLineSeparatorAnimating(true);
        this.clockAnimData.setLineSeparatorAlpha(startAlpha);
        return endAlpha;
      }
      return ANIM_MIN_VALUE;
    }
    // 保持可见，分隔符类型切换场景
    let startAlpha = prepare.isCurSeparateLine ? ANIM_MIN_VALUE : ANIM_MAX_VALUE;
    let endAlpha = prepare.isCurSeparateLine ? ANIM_MAX_VALUE : ANIM_MIN_VALUE;
    this.clockAnimData.setLineSeparatorAnimating(true);
    this.clockAnimData.setLineSeparatorAlpha(startAlpha);
    return endAlpha;
  }

  /**
   * 点分隔符透明度初始化
   *
   * @param prepare 预备参数
   * @returns 动效终值
   */
  private initPointAlphaAnim(prepare: AnimPrepareParam): number {
    if (prepare.isPreSeparateShow !== prepare.isCurSeparateShow) { // 可见性切换，直接alpha过渡
      if (!prepare.isCurSeparateLine) { // 点分隔符动效生效
        let startAlpha = prepare.isCurSeparateShow ? ANIM_MIN_VALUE : ANIM_MAX_VALUE;
        let endAlpha = prepare.isCurSeparateShow ? ANIM_MAX_VALUE : ANIM_MIN_VALUE;
        this.clockAnimData.setPointSeparatorAnimating(true);
        this.clockAnimData.setPointSeparatorAlpha(startAlpha);
        return endAlpha;
      }
      return ANIM_MIN_VALUE;
    }
    // 保持可见，分隔符类型切换场景
    let startAlpha = !prepare.isCurSeparateLine ? ANIM_MIN_VALUE : ANIM_MAX_VALUE;
    let endAlpha = !prepare.isCurSeparateLine ? ANIM_MAX_VALUE : ANIM_MIN_VALUE;
    this.clockAnimData.setPointSeparatorAnimating(true);
    this.clockAnimData.setPointSeparatorAlpha(startAlpha);
    return endAlpha;
  }

  /**
   * 切换日期、星期等样式
   */
  protected updateDateWeekLunarStyle(): void {
    if (this.clockStaticState.updateDateWeekLunarStyle()) { // 日期、星期等样式切换，可见性切换
      this.clockBindState.dateWeekStyle = this.clockStaticState.dateWeekStyle;
      this.clockBindState.isShowLargeDate = this.clockStaticState.isShowLargeDate;
      this.clockBindState.isMergeWeekLunar = this.clockStaticState.isMergeWeekLunar;
      this.clockBindState.batteryPosition = this.clockStaticState.batteryPosition ?? BatteryPosition.SEPARATE;
    }
  }

  /**
   * 更新时钟网格配置
   */
  protected updateClockGridParam(): void {
    clockLayoutParam.updateGridParam(this.clockStaticState.getCurGrid());
    if (this.clockStaticState.updateClockViewMargin()) { // 同步更新时钟组件间距
      this.clockBindState.clockMarginLeft = this.clockStaticState.clockMarginLeft;
      this.clockBindState.clockMarginTop = this.clockStaticState.clockMarginTop;
      log.showWarn(`updateClockGridParam left:${this.clockBindState.clockMarginLeft}` +
        `top:${this.clockBindState.clockMarginTop}`);
    }
  }

  /**
   * 更新时钟元素参数
   *
   * @param newConf 参数集
   * @param indexes 更新元素索引
   */
  private updateElement(newConf?: ElementConf[], indexes?: number[]): void {
    if (indexes) { // 分散更新
      indexes.forEach((index) => {
        clockLayoutParam.updateSingleElement(newConf?.[index]);
      });
      clockLayoutParam.calcFontSizeByFontFamily(this.clockLayoutModifier);
      return;
    }
    // 统一更新
    clockLayoutParam.updateElementConfig(newConf, false, false, this.clockLayoutModifier);
  }

  /**
   * 主动效弹簧动效监听
   *
   * @param prepare 预备参数
   * @returns 动效监听器
   */
  private getMainSpringAnimListener(prepare: AnimPrepareParam): AnimationStateListener {
    let listener: AnimationStateListener = {
      onAnimationEnd: (): void => {
        if (!this.hasAnimListener(prepare.mainAnimScene)) { // 动效已打断
          log.showWarn(`getMainSpringAnimListener anim has interrupt: ${prepare.mainAnimScene}`);
          return;
        }
        this.clockAnimData.clearAllAnim();
        prepare.animListener?.onAnimationEnd?.();
        this.removeAnimListener(prepare.mainAnimScene);
        NotificationStateManager.updateClockAnimDelayState(false);
        TraceUtil.endAnimTrace(DomainName.KG, prepare.mainAnimScene);
      }
    };
    this.addAnimListener(prepare.mainAnimScene, listener);
    return listener;
  }

  /**
   * 分隔符透明度动效监听
   *
   * @param scene 动效场景
   * @returns 动效监听器
   */
  protected getSeparatorAlphaListener(scene: AnimScene): AnimationStateListener {
    let listener: AnimationStateListener = {
      onAnimationEnd: (): void => {
        if (!this.hasAnimListener(scene)) { // 动效已打断
          return;
        }
        this.clockAnimData?.clearSeparatorAnim();
        this.removeAnimListener(scene);
      }
    };
    this.addAnimListener(scene, listener);
    return listener;
  }

  /**
   * 收起/展开动效状态
   *
   * @param prepare 动效预备参数
   * @returns true收起动效
   */
  protected isAnimCollapse(prepare: AnimPrepareParam): boolean {
    return prepare.mainAnimScene === AnimScene.SCENE_MAIN_COLLAPSE;
  }

  /**
   * 动效前准备参数
   *
   * @param param 动效入参
   * @returns 动效前准备参数
   */
  protected getAnimPrepareParam(param: ClockAnimParam): AnimPrepareParam {
    let preGrid = clockLayoutParam.gridParam;
    let curGrid = this.clockStaticState?.getCurGrid();
    let conf = this.clockStaticState?.getCurElementConf();
    return {
      mainAnimScene: param.isAnimToExpand ? AnimScene.SCENE_MAIN_EXPAND : AnimScene.SCENE_MAIN_COLLAPSE,
      sepAlphaScene: param.isAnimToExpand ? AnimScene.SCENE_SEP_ALPHA_EXPAND : AnimScene.SCENE_SEP_ALPHA_COLLAPSE,
      isTimeSeparate: preGrid.isTimeSeparate ?? false,
      isPreSeparateShow: clockLayoutParam.separatorConf.isShow,
      isCurSeparateShow: conf?.[ElementConfIndex.SEPARATOR]?.isShow ?? false,
      isPreSeparateLine: preGrid.specialSeparator,
      isCurSeparateLine: curGrid?.specialSeparator ?? false,
      isPreLargeDate: preGrid.largeDate && preGrid.dateSeperate,
      isCurLargeDate: (curGrid?.largeDate ?? false) && (curGrid?.dateSeperate ?? false),
      animListener: param.animListener
    };
  }

  /**
   * 动效曲线
   *
   * @param animType 类型
   * @param vel 速度
   * @returns 参数
   */
  protected getAnimCurve(animType: AnimParamType, vel: number = 0): ICurve | Curve {
    switch (animType) {
      case AnimParamType.MAIN_SPRING:
        return curves.interpolatingSpring(vel, 1, 228, 24.5);
      case AnimParamType.OTHER_THEME_INTO_IMMERSIVE:
      case AnimParamType.OTHER_THEME_EXIT_IMMERSIVE:
        return curves.interpolatingSpring(0, 1, 228, 30);
      case AnimParamType.SECONDARY_CUBIC_BEZIER:
      case AnimParamType.OTHER_THEME_INTO_IMMERSIVE_ALPHA:
      case AnimParamType.OTHER_THEME_EXIT_IMMERSIVE_ALPHA:
        return curves.cubicBezierCurve(0.4, 0, 0.4, 1);
      default :
        return Curve.Linear;
    }
  }

  /**
   * 加入动效监听
   *
   * @param scene 动效场景
   * @param listener 监听
   */
  protected addAnimListener(scene: AnimScene, listener: AnimationStateListener): void {
    this.animSceneListener.set(scene, listener);
  }

  /**
   * 移除动效监听
   *
   * @param scene 动效场景
   */
  protected removeAnimListener(scene: AnimScene): void {
    this.animSceneListener.delete(scene);
  }

  /**
   * 当前是否动效中
   *
   * @param scene 动效场景
   * @returns true动效中
   */
  protected hasAnimListener(scene: AnimScene): boolean {
    return this.animSceneListener.has(scene);
  }

  /**
   * 打断动效
   *
   * @param scene 动效场景
   */
  protected interceptAnimScene(scene: AnimScene): void {
    this.animSceneListener.get(scene)?.onAnimationEnd?.();
  }

  /**
   * 三方主题场景进入沉浸态时钟动效
   *
   * @param setClockShow 设置时钟显示
   */
  public doIntoImmersiveAnim(setClockShow: () => void): void {
    this.slClockAnimCtrl?.setAnimScene({isAnimating: true, animScene: AnimScene.SCENE_INTO_IMMERSIVE})
      .setAlpha(0)
      .setBlur(IMMERSIVE_CLOCK_BLUR)
      .setScaleX(IMMERSIVE_CLOCK_SCALE)
      .setScaleY(IMMERSIVE_CLOCK_SCALE);
    setClockShow?.();
    TraceUtil.startTrace(DomainName.KG, AnimScene.SCENE_INTO_IMMERSIVE);
    animateTo({
      curve: this.getAnimCurve(AnimParamType.OTHER_THEME_INTO_IMMERSIVE),
      onFinish: () => {
        TraceUtil.endTrace(DomainName.KG, AnimScene.SCENE_INTO_IMMERSIVE);
        if (this.slClockAnimCtrl?.isSceneAnimating(AnimScene.SCENE_INTO_IMMERSIVE)) {
          this.clearClockAnimState(AnimScene.SCENE_INTO_IMMERSIVE);
        }
      }
    }, () => {
      this.slClockAnimCtrl?.setBlur(0).setScaleX(DEFAULT_VALUE).setScaleY(DEFAULT_VALUE);
    })

    animateTo({
      curve: this.getAnimCurve(AnimParamType.OTHER_THEME_INTO_IMMERSIVE_ALPHA),
      duration: IMMERSIVE_CLOCK_ALPHA_DURATION
    }, () => {
      this.slClockAnimCtrl?.setAlpha(DEFAULT_VALUE);
    })
  }

  private clearClockAnimState(scene: string): void {
    this.slClockAnimCtrl?.setAnimScene({isAnimating: false, animScene: scene})
      .setAlpha()
      .setBlur()
      .setScaleX()
      .setScaleY();
  }

  /**
   * 三方主题场景退出沉浸态时钟动效
   *
   * @param animCallBack 动效回调
   */
  public doExitImmersiveAnim(animCallBack: () => void): void {
    if (this.slClockAnimCtrl?.isSceneAnimating(AnimScene.SCENE_INTO_IMMERSIVE)) {
      this.clearClockAnimState(AnimScene.SCENE_INTO_IMMERSIVE);
    }

    this.slClockAnimCtrl?.setAnimScene({isAnimating: true, animScene: AnimScene.SCENE_EXIT_IMMERSIVE})
      .setAlpha(DEFAULT_VALUE)
      .setBlur(0)
      .setScaleX(DEFAULT_VALUE)
      .setScaleY(DEFAULT_VALUE);
    TraceUtil.startTrace(DomainName.KG, AnimScene.SCENE_EXIT_IMMERSIVE);
    animateTo({
      curve: this.getAnimCurve(AnimParamType.OTHER_THEME_EXIT_IMMERSIVE),
      onFinish: () => {
        TraceUtil.endTrace(DomainName.KG, AnimScene.SCENE_EXIT_IMMERSIVE);
      }
    }, () => {
      this.slClockAnimCtrl?.setBlur(IMMERSIVE_CLOCK_BLUR)
        .setScaleX(IMMERSIVE_CLOCK_SCALE)
        .setScaleY(IMMERSIVE_CLOCK_SCALE);
    })

    animateTo({
      curve: this.getAnimCurve(AnimParamType.OTHER_THEME_EXIT_IMMERSIVE_ALPHA),
      duration: IMMERSIVE_CLOCK_ALPHA_DURATION,
      onFinish: () => {
        animCallBack?.();
        this.clearClockAnimState(AnimScene.SCENE_EXIT_IMMERSIVE);
      }
    }, () => {
      this.slClockAnimCtrl?.setAlpha(0);
    })
  }
}