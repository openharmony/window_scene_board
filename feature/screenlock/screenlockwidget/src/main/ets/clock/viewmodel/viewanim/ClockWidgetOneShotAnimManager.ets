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
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { obtainLocalEvent, sEventManager } from '@ohos/frameworkwrapper';
import { ScreenLockToDesktopConsts, ClockOneShortConsts, slClockOneShotToDesktopService } from '@ohos/screenlockcommon';
import { clockLayoutParam, ElementConf } from '../../common/ClockLayoutParam';
import { ClockAnimData } from '../../model/data/ClockAnimData';
import { ClockBindData } from '../../model/data/ClockBindData'
import { ClockStaticData } from '../../model/data/ClockStaticData'
import {
  AnimParamType,
  AnimPrepareParam, AnimScene,
  ANIM_MAX_VALUE,
  ANIM_MIN_VALUE,
  ClockAnimParam, ClockWidgetAnimManager,
  OTHER_LINE,
  SEPARATOR_ALPHA_DELAY,
  SEPARATOR_ALPHA_DURATION,
  TIME_FIRST_LINE,
  TIME_SPRING_DELAY,
  DESKTOP_TO_AOD_TIME_SPRING_DELAY,
  AOD_TO_DESKTOP_SEPARATOR_ALPHA_DELAY,
  DESKTOP_AND_AOD_ANI_DELAY } from './ClockWidgetAnimManager'
import curves from '@ohos.curves';
import { slStateHelper } from '../../../common/utils/SlStateHelper';
import { SlClockBindState } from '../../model/data/SlClockBindState';
import { UDFontAdapterUtil } from '../../common/UDFontAdapterUtil';
import { clockLayoutHelper } from '../../common/ClockLayoutHelper';
import { ClockHookType } from '../../../common/adapter/Constans';
import { AnimationStateListener, CommonAnimationUtil } from '../../../common/utils/AnimationUtil';
import { FontSizeKeyHelper } from '../../common/ClockFontSize';

const TAG = 'ClockWidgetOneShotAnimManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const TIME_START_PROGRESS = 80 / 830;
const CALL_ANIMATION_END_DELAY = 350;
const CALL_ANIMATION_END_DELAY_FOR_FACE_AND_FINGER = 450;
const FONTSIZE_ANI_DURATION = 300;
const ONESHOT_ANIM_MAX_SLIDING_DISTANCE = 750;
const CLOCK_ANI_PROGRESS_SCALE = 1.5;
const NO_TIME_ANI_PROGRESS_SCALE = 2;
const MAX_CLOCK_ANIMATION_PROGRESS: number = 1;
const DATE_ALPHA_DURATION = 150; // 日期透明度动效时长
const CALL_ANIMATION_END_DELAY_FOR_AOD_TO_DESKTOP = 720; // AOD、 桌面间时钟动效最大时长
const CALL_ANIMATION_END_DELAY_FOR_PART_AOD_TO_SL = 1000; // AOD、 锁屏间时钟动效最大时长
const UNIT_FONTSIZE_ANI_DELAY = 40; // 非分散场景字体动效延迟
const SEP_FONTSIZE_ANI_DELAY = 20; // 分散场景字体动效延迟
const DESKTOP_TO_AOD_FONT_DURATION = 600; // 桌面到AOD字号动效时长
const DESKTOP_CLOCK_FONT_SIZE: number = 88;
const OUTER_DESKTOP_CLOCK_FONT_SIZE: number = 60;
const ANIM_TIMEOUT_TIME: Map<String, number> = new Map([
  [ScreenLockToDesktopConsts.FACE_TO_DESKTOP_CLOCK_ANIMATION, CALL_ANIMATION_END_DELAY_FOR_FACE_AND_FINGER],
  [ScreenLockToDesktopConsts.FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION, CALL_ANIMATION_END_DELAY_FOR_FACE_AND_FINGER],
  [ScreenLockToDesktopConsts.KEYPRESS_TO_DESKTOP_CLOCK_ANIMATION, CALL_ANIMATION_END_DELAY_FOR_FACE_AND_FINGER],
  [ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION, CALL_ANIMATION_END_DELAY_FOR_AOD_TO_DESKTOP],
  [ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION, CALL_ANIMATION_END_DELAY_FOR_AOD_TO_DESKTOP],
  [ClockOneShortConsts.PART_AOD_TO_DESKTOP_CLOCK_ANIMATION, CALL_ANIMATION_END_DELAY_FOR_PART_AOD_TO_SL],
  [ClockOneShortConsts.DESKTOP_TO_PART_AOD_CLOCK_ANIMATION, CALL_ANIMATION_END_DELAY_FOR_PART_AOD_TO_SL],
  [ClockOneShortConsts.SL_TO_PART_AOD_CLOCK_ANIMATION, CALL_ANIMATION_END_DELAY_FOR_PART_AOD_TO_SL],
  [ClockOneShortConsts.PART_AOD_TO_SL_CLOCK_ANIMATION, CALL_ANIMATION_END_DELAY_FOR_PART_AOD_TO_SL],
]);

export class ClockWidgetOneShotAnimManager extends ClockWidgetAnimManager {
  private isOnOneShotAnim: boolean = false;
  private isScreenOrientationHasLocked: boolean = false;
  private prepareForSeparatorSuccess: boolean = false;
  private lastMoveProgress: number = 0;
  private endLineAlpha: number = 0;
  private endPointAlpha: number = 0;
  private prepareAnimPrepareParam: AnimPrepareParam = {
    mainAnimScene: AnimScene.SCENE_MAIN_COLLAPSE,
    sepAlphaScene: AnimScene.SCENE_SEP_ALPHA_COLLAPSE,
    isTimeSeparate: false,
    isPreSeparateShow: false,
    isCurSeparateShow: false,
    isPreSeparateLine: false,
    isCurSeparateLine: false,
    isPreLargeDate: false,
    isCurLargeDate: false
  };

  public getHookType(): ClockHookType {
    return ClockHookType.CLOCK_ANIM_MANAGER;
  }

  public getIsOnOneShotAnim(): boolean {
    return this.isOnOneShotAnim;
  }

  /**
   * 开启时钟元素收起、展开状态切换动效
   *
   * @param param 动效入参
   */
  public startCollapseStateChangeAnimForOneShot(param: ClockAnimParam, oneShotAnimScene: string): void {
    log.showInfo('oneShot call startCollapseStateChangeAnimForOneShot start');
    if (!this.clockStaticState.getCurElementConf()) {
      log.showWarn(`oneShot startCollapseStateChangeAnimForOneShot invalid param: ${param.isAnimToExpand}`)
      return;
    }

    this.interceptAnimScene(AnimScene.SCENE_MAIN_COLLAPSE); // 打断已有动效
    this.interceptAnimScene(AnimScene.SCENE_MAIN_EXPAND);
    let prepare = this.getAnimPrepareParam(param);
    TraceUtil.startAnimTrace(DomainName.KG, prepare.mainAnimScene);
    prepare.animListener?.onAnimationStart?.(); // 动效开启回调
    this.startSeparatorAlphaAnimForOneShot(prepare, oneShotAnimScene); // 分隔符alpha动效
    if (oneShotAnimScene === ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION ||
      oneShotAnimScene === ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION) {
      this.startAllElementAnimForDesktopAodOneShot(prepare, oneShotAnimScene);
    } else {
      this.startAllElementAnimForOneShot(prepare, oneShotAnimScene); // 全元素统一过渡动效
    }
    log.showInfo('oneShot call startCollapseStateChangeAnimForOneShot end');
  }

  /**
   * 开启分隔符透明度过渡动效
   *
   * @param prepare 预备参数
   */
  protected startSeparatorAlphaAnimForOneShot(prepare: AnimPrepareParam, oneShotAnimScene: string)
    : void {
    if (!prepare.isPreSeparateShow && !prepare.isCurSeparateShow) { // 分割符始终不可见，不涉及动效
      return;
    }
    if (prepare.isPreSeparateShow && prepare.isCurSeparateShow &&
      prepare.isPreSeparateLine === prepare.isCurSeparateLine) { // 分割符可见且无切换，不涉及动效
      return;
    }
    this.interceptAnimScene(AnimScene.SCENE_SEP_ALPHA_COLLAPSE); // 打断已有alpha动效
    this.interceptAnimScene(AnimScene.SCENE_SEP_ALPHA_EXPAND);
    let lineEndAlpha = this.initLineAlphaAnimForOneShot(prepare, oneShotAnimScene);
    let pointEndAlpha = this.initPointAlphaAnimForOneShot(prepare, oneShotAnimScene);
    // 动效场景，收起动效延时启动
    let delay = this.isAnimCollapse(prepare) ? SEPARATOR_ALPHA_DELAY : ANIM_MIN_VALUE;

    switch (oneShotAnimScene) {
      case ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION:
        delay = 0;
        break;
      case ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION:
      case ClockOneShortConsts.PART_AOD_TO_DESKTOP_CLOCK_ANIMATION:
        delay = DESKTOP_AND_AOD_ANI_DELAY + AOD_TO_DESKTOP_SEPARATOR_ALPHA_DELAY;
        break;
      case ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION:
      case ClockOneShortConsts.DESKTOP_TO_PART_AOD_CLOCK_ANIMATION:
        delay = DESKTOP_AND_AOD_ANI_DELAY;
        break;
      default:
        break;
    }

    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.SECONDARY_CUBIC_BEZIER), delay,
      SEPARATOR_ALPHA_DURATION, () => {
        if (this.clockAnimData.lineSeparatorAnimating) {
          this.clockAnimData.setLineSeparatorAlpha(lineEndAlpha);
        }
        if (this.clockAnimData.pointSeparatorAnimating) {
          this.clockAnimData.setPointSeparatorAlpha(pointEndAlpha);
        }
      }, this.getSeparatorAlphaListener(prepare.sepAlphaScene));
  }

  /**
   * 线分隔符透明度初始化
   *
   * @param prepare 预备参数
   * @returns 动效终值
   */
  private initLineAlphaAnimForOneShot(prepare: AnimPrepareParam, oneShotAnimScene: string): number {
    if (prepare.isPreSeparateShow !== prepare.isCurSeparateShow) { // 可见性切换，直接alpha过渡
      if (prepare.isCurSeparateLine) { // 线分隔符动效生效
        let startAlpha = prepare.isCurSeparateShow ? ANIM_MIN_VALUE : ANIM_MAX_VALUE;
        let endAlpha = prepare.isCurSeparateShow ? ANIM_MAX_VALUE : ANIM_MIN_VALUE;
        this.clockAnimData.setLineSeparatorAnimating(true);
        if (oneShotAnimScene !== ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION) {
          this.clockAnimData.setLineSeparatorAlpha(startAlpha);
        }
        return endAlpha;
      }
      return ANIM_MIN_VALUE;
    }
    // 保持可见，分隔符类型切换场景
    let startAlpha = prepare.isCurSeparateLine ? ANIM_MIN_VALUE : ANIM_MAX_VALUE;
    let endAlpha = prepare.isCurSeparateLine ? ANIM_MAX_VALUE : ANIM_MIN_VALUE;
    this.clockAnimData.setLineSeparatorAnimating(true);
    if (oneShotAnimScene !== ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION) {
      this.clockAnimData.setLineSeparatorAlpha(startAlpha);
    }
    return endAlpha;
  }

  /**
   * 点分隔符透明度初始化
   *
   * @param prepare 预备参数
   * @returns 动效终值
   */
  private initPointAlphaAnimForOneShot(prepare: AnimPrepareParam, oneShotAnimScene: string): number {
    if (prepare.isPreSeparateShow !== prepare.isCurSeparateShow) { // 可见性切换，直接alpha过渡
      if (!prepare.isCurSeparateLine) { // 点分隔符动效生效
        let startAlpha = prepare.isCurSeparateShow ? ANIM_MIN_VALUE : ANIM_MAX_VALUE;
        let endAlpha = prepare.isCurSeparateShow ? ANIM_MAX_VALUE : ANIM_MIN_VALUE;
        this.clockAnimData.setPointSeparatorAnimating(true);
        if (oneShotAnimScene !== ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION) {
          this.clockAnimData.setPointSeparatorAlpha(startAlpha);
        }
        return endAlpha;
      }
      return ANIM_MIN_VALUE;
    }
    // 保持可见，分隔符类型切换场景
    let startAlpha = !prepare.isCurSeparateLine ? ANIM_MIN_VALUE : ANIM_MAX_VALUE;
    let endAlpha = !prepare.isCurSeparateLine ? ANIM_MAX_VALUE : ANIM_MIN_VALUE;
    this.clockAnimData.setPointSeparatorAnimating(true);
    if (oneShotAnimScene !== ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION) {
      this.clockAnimData.setPointSeparatorAlpha(startAlpha);
    }
    return endAlpha;
  }

  /**
   * 开启全元素整体过渡场景动效
   *
   * @param prepare 预备参数
   */
  private startAllElementAnimForOneShot(prepare: AnimPrepareParam, oneShotAnimScene: string)
    : void {
    let elementConf = this.clockStaticState.getCurElementConf();
    if (prepare.isTimeSeparate) { // 离散小时、分钟类型
      let isCollapse = this.isAnimCollapse(prepare);
      let firstLineDelay = isCollapse ? ANIM_MIN_VALUE : TIME_SPRING_DELAY; // 第一行展开时delay
      let otherDelay = isCollapse ? TIME_SPRING_DELAY : ANIM_MIN_VALUE; // 其他行收起时delay

      if (oneShotAnimScene === ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION) {
        firstLineDelay = 0;
        otherDelay = 0;
      }

      this.createSeparateAnimateTo(firstLineDelay, elementConf, oneShotAnimScene, isCollapse, prepare, otherDelay);
      return;
    }
    // 统一动效
    this.createUnitAnimateTo(elementConf, oneShotAnimScene, prepare);
  }

  /**
   * 开启桌面和AOD间时钟动效
   *
   * @param prepare 预备参数
   * @param oneShotAnimScene 动效场景
   */
  private startAllElementAnimForDesktopAodOneShot(prepare: AnimPrepareParam, oneShotAnimScene: string): void {
    log.showInfo(`startAllElementAnimForDesktopAodOneShot ${this.clockStaticState.isClockToCollapseOnDesktop}
      sIsClockWidgetExpand ${ClockStaticData.sIsClockWidgetExpand}`);
    // 离散小时、分钟类型
    if (prepare.isTimeSeparate) {
      if (oneShotAnimScene === ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION) {
        this.createDeskTopToAodSeparateAnimateTo(prepare);
      } else if (oneShotAnimScene === ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION) {
        this.createAodToDesktopSeparateAnimateTo(prepare);
      }
      return;
    }
    this.createDesktopAndAodUnitAnimateTo(oneShotAnimScene, prepare);
  }

  /**
   * 桌面到AOD间非离散时钟动效
   *
   * @param oneShotAnimScene 动效场景
   * @param prepare 预备参数
   */
  private createDesktopAndAodUnitAnimateTo(oneShotAnimScene: string, prepare: AnimPrepareParam) {
    log.showInfo('oneShot startAllElementAnimForOneShot with createDesktopAndAodUnitAnimateTo');
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.DESKTOP_AOD_SPRING, 0),
      DESKTOP_AND_AOD_ANI_DELAY, undefined,
      () => {
        this.updateClockGridParam();
        this.refreshClockParamInAnim(true, this.clockStaticState.getCurElementConf());
      }, this.getMainSpringAnimListenerForOneShot(prepare, oneShotAnimScene));
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.SECONDARY_CUBIC_BEZIER, 0),
      DESKTOP_AND_AOD_ANI_DELAY, DATE_ALPHA_DURATION, () => {
        this.updateNoTimeViewOpacity();
      }, undefined);
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.DESKTOP_AOD_SPRING, 0),
      DESKTOP_AND_AOD_ANI_DELAY + UNIT_FONTSIZE_ANI_DELAY, FONTSIZE_ANI_DURATION, () => {
        // 可能出现上面主动效已经打断,finished回调已经结束,子动效还在执行的情况.
        if (this.getIsOnOneShotAnim()) {
          if (oneShotAnimScene === ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION) {
            this.updateFontSizeAfterScreenOff();
          } else if (oneShotAnimScene === ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION) {
            this.updateFontSizeAfterSlideUp();
          }
        }
      }, undefined);
  }

  private updateFontSizeAfterScreenOff(): void {
    let screenLockClockFontSize: number = this.clockStaticState.getScreenLockTimeFontSize();
    log.showInfo(`oneShot updateFontSizeAfterScreenOff: ${screenLockClockFontSize}`);
    this.clockStaticState.updateFontSizeAfterScreenOff(screenLockClockFontSize);
    this.clockBindState.fontSizeAfterSlideUp = this.clockStaticState.fontSizeAfterSlideUp;
  }

  private createUnitAnimateTo(elementConf: ElementConf[] | undefined, oneShotAnimScene: string,
    prepare: AnimPrepareParam) {
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.MAIN_SPRING, 0), 0, undefined,
      () => {
        this.updateClockGridParam();
        this.updateElementForOneShot(true, elementConf);

        this.updateClockOffset();
        this.updateNoTimeViewOpacity();
        this.updateTimeViewOpacity();
        this.updateTextColor();
        this.updateTextOffSets();
        this.updateScaleOptions();
        if (oneShotAnimScene !== ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION) {
          this.updateHourMinuteAndSeparatorFontSize(this.getDesktopClockFontSize(), true);
        }
      }, this.getMainSpringAnimListenerForOneShot(prepare, oneShotAnimScene));
  }

  private createSeparateAnimateTo(firstLineDelay: number, elementConf: ElementConf[] | undefined,
    oneShotAnimScene: string, isCollapse: boolean, prepare: AnimPrepareParam,
    otherDelay: number) {
    log.showInfo(`oneShot startAllElementAnimForOneShot with createAnimateTo firstLineDelay = ${firstLineDelay}`);
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.MAIN_SPRING, 0),
      firstLineDelay, undefined, () => {
        this.updateElementForOneShot(true, elementConf, TIME_FIRST_LINE);
        if (oneShotAnimScene !== ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION) {
          this.updateHourFontSize(this.getDesktopClockFontSize(), true);
        }
      }, isCollapse ? undefined : this.getMainSpringAnimListenerForOneShot(prepare, oneShotAnimScene));
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.MAIN_SPRING, 0),
      otherDelay, undefined, () => {
        this.updateClockGridParam();
        this.updateElementForOneShot(true, elementConf, OTHER_LINE);

        this.updateClockOffset();
        this.updateNoTimeViewOpacity();
        this.updateTimeViewOpacity();
        this.updateTextColor();
        this.updateTextOffSets();
        this.updateScaleOptions();
        if (oneShotAnimScene !== ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION) {
          this.updateMinuteAndSeparatorFontSize(this.getDesktopClockFontSize(), true);
        }
      }, isCollapse ? this.getMainSpringAnimListenerForOneShot(prepare, oneShotAnimScene) : undefined);
  }

  /**
   * 桌面到AOD的离散时钟动效
   *
   * @param elementConf 元素配置
   * @param prepare 预备参数
   */
  private createDeskTopToAodSeparateAnimateTo(prepare: AnimPrepareParam) {
    log.showInfo('oneShot startAllElementAnimForOneShot with createDeskTopToAodSeparateAnimateTo');
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.DESKTOP_AOD_SPRING, 0),
      DESKTOP_AND_AOD_ANI_DELAY + DESKTOP_TO_AOD_TIME_SPRING_DELAY, undefined, () => {
        this.refreshClockParamInAnim(false, this.clockStaticState.getCurElementConf(), TIME_FIRST_LINE);
        let screenLockTimeFontSize: number = this.getTargetClockFontSize();
        log.showInfo(`oneShot updateHourFontSize: ${screenLockTimeFontSize}`);
        this.updateHourFontSize(screenLockTimeFontSize, true);
      },
      this.getMainSpringAnimListenerForOneShot(prepare, ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION));
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.DESKTOP_AOD_SPRING, 0),
      DESKTOP_AND_AOD_ANI_DELAY, undefined,
      () => {
        this.updateClockGridParam();
        this.updateElementForOneShot(false, this.clockStaticState.getCurElementConf(), OTHER_LINE);
        let screenLockTimeFontSize: number = this.getTargetClockFontSize();
        log.showInfo(`oneShot updateMinuteAndSeparatorFontSize: ${screenLockTimeFontSize}`);
        this.updateMinuteAndSeparatorFontSize(screenLockTimeFontSize, true);
      }, undefined);
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.SECONDARY_CUBIC_BEZIER, 0),
      DESKTOP_AND_AOD_ANI_DELAY, DATE_ALPHA_DURATION, () => {
        this.updateNoTimeViewOpacity();
      }, undefined);
  }

  /**
   * AOD到桌面的离散时钟动效
   *
   * @param prepare 预备参数
   */
  private createAodToDesktopSeparateAnimateTo(prepare: AnimPrepareParam) {
    log.showInfo('oneShot startAllElementAnimForOneShot with createAodToDesktopSeparateAnimateTo');
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.DESKTOP_AOD_SPRING, 0),
      0, undefined, () => {
        this.updateElementForOneShot(true, this.clockStaticState.getCurElementConf(), TIME_FIRST_LINE);
        let desktopClockFontSize: number = this.getTargetClockFontSize();
        log.showInfo(`oneShot updateHourFontSize: ${desktopClockFontSize}`);
        this.updateHourFontSize(desktopClockFontSize, true);
      }, undefined);
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.DESKTOP_AOD_SPRING, 0),
      TIME_SPRING_DELAY, undefined, () => {
        this.updateClockGridParam();
        this.refreshClockParamInAnim(true, this.clockStaticState.getCurElementConf(), OTHER_LINE);
        let desktopClockFontSize: number = this.getTargetClockFontSize();
        log.showInfo(`oneShot updateMinuteAndSeparatorFontSize: ${desktopClockFontSize}`);
        this.updateMinuteAndSeparatorFontSize(desktopClockFontSize, true);
      },
      this.getMainSpringAnimListenerForOneShot(prepare, ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION));
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.SECONDARY_CUBIC_BEZIER, 0),
      0, DATE_ALPHA_DURATION, () => {
        this.updateNoTimeViewOpacity();
      }, undefined);
  }

  protected updateClockOffset(useOldClockRectInfo?: boolean): void {
    if (this.clockStaticState.updateClockOffset(useOldClockRectInfo)) { // 同步更新时钟组件偏移
      this.clockBindState.clockOffsetX = this.clockStaticState.clockOffsetX;
      this.clockBindState.clockOffsetY = this.clockStaticState.clockOffsetY;
      log.showInfo(`oneShot clockBindState.clockOffsetX=${
        this.clockBindState.clockOffsetX} clockBindState.clockOffsetY=${this.clockBindState.clockOffsetY}`)
    }
  }

  protected updateNoTimeViewOpacity(): void {
    if (this.clockStaticState.updateNoTimeViewOpacity()) { // 同步日历、星期、农历等透明度
      this.clockBindState.noTimeViewOpacity = this.clockStaticState.noTimeViewOpacity;
    }
  }

  protected updateTimeViewOpacity(): void {
    if (this.clockStaticState.updateTimeViewOpacity()) { // 同步时间透明度
      this.clockBindState.timeViewOpacity = this.clockStaticState.timeViewOpacity;
    }
  }

  protected updateTextColor(): void {
    if (this.clockStaticState.updateTextColor()) {
      log.showInfo(`oneShot updateTextColor clockBindState.textColor=${this.clockBindState.textColor}
        clockStaticState.textColor=${this.clockStaticState.textColor}`)
      this.clockBindState.textColor = this.clockStaticState.textColor;
    }
  }

  protected updateTextOffSets(): void {
    this.clockStaticState.updateTextOffSets(this.getDesktopClockFontSize());
    if (this.clockStaticState.textOffSets.isEmpty()) {
      this.clockBindState.textOffSets.clear();
    } else {
      this.clockBindState.textOffSets.setAll(this.clockStaticState.textOffSets);
    }
  }

  protected updateScaleOptions(): void {
    this.clockStaticState.updateScaleOptions();
    log.showInfo(`oneShot updateScaleOptions scaleX=${this.clockStaticState.scaleOptions?.x},
    scaleY=${this.clockStaticState.scaleOptions?.y}`);
    this.clockBindState.scaleOptions = this.clockStaticState.scaleOptions;
  }

  protected updateFontSizeAfterSlideUp(): void {
    let desktopClockFontSize: number = this.getDesktopClockFontSize();
    log.showInfo(`oneShot updateFontSizeAfterSlideUp: ${desktopClockFontSize}`);
    this.clockStaticState.updateFontSizeAfterSlideUp(desktopClockFontSize);
    this.clockBindState.fontSizeAfterSlideUp = this.clockStaticState.fontSizeAfterSlideUp;
  }

  /**
   * 主动效弹簧动效监听
   *
   * @param prepare 预备参数
   * @returns 动效监听器
   */
  protected getMainSpringAnimListenerForOneShot(prepare: AnimPrepareParam, oneShotAnimScene: string)
    : AnimationStateListener {
    let listener: AnimationStateListener = {
      onAnimationStart: (): void => {
        log.showInfo(`oneShot getMainSpringAnimListener onAnimationStart ${oneShotAnimScene}`);
        if (oneShotAnimScene !== undefined) {
          this.isOnOneShotAnim = true;
        }
        this.isScreenOrientationHasLocked = SCBScreenSessionManager.getInstance().getScreenOrientationLocked();
        if (!this.isScreenOrientationHasLocked) {
          SCBScreenSessionManager.getInstance().setScreenOrientationLocked(true);
        }
      },
      onAnimationEnd: (): void => {
        log.showInfo(`oneShot getMainSpringAnimListener onAnimationEnd ${oneShotAnimScene}`);
        if (!this.hasAnimListener(prepare.mainAnimScene)) { // 动效已打断
          return;
        }
        this.clockAnimData.clearAllAnim();
        prepare.animListener?.onAnimationEnd?.();
        this.removeAnimListener(prepare.mainAnimScene);
        if (oneShotAnimScene === ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION ||
          oneShotAnimScene === ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION) {
          // 此场景下，分隔符和其他元素共用一个animationTo方法，所以这里需要清除分隔符动效
          log.showInfo('oneShot call getMainSpringAnimListener clearSeparatorAnim');
          this.clockAnimData.clearSeparatorAnim();
        }
        const slClockBindCtrl = slStateHelper.getSlClockBindState();
        if (oneShotAnimScene !== ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION) {
          // 如果存在字号的缩放效果
          if (clockLayoutParam.hourConf0.fontSizeScale !== 1) {
            this.updateHourMinuteAndSeparatorFontSize(this.getDesktopClockFontSize());
          }
          slClockBindCtrl?.setRemoveBrightness(false);
          // 如果在非桌面到AOD时钟动效过程中, 触发了桌面到AOD时钟动效, 则不发送解锁消息
          this.sendMessageToUnlock(oneShotAnimScene);
          sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.DESKTOP_CLOCK_ANIMATION_START, null));
          log.showInfo(`onAnimationEnd clock unlock anim:${slClockBindCtrl?.getClockDesktopToAod()}`);
        } else {
          // 如果在桌面到AOD时钟动效过程中, 触发了解锁到桌面的时钟动效, 则不发送加锁消息
          if (!slClockBindCtrl?.getClockAodToDesktop() && !this.clockStaticState.isClockToCollapseOnDesktop) {
            sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_LOCKING, null));
            sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.DESKTOP_TO_AOD_ANIM_FINISHED, null));
          } else {
            slClockBindCtrl?.setClockDesktopToAod(false);
          }
        }
        this.isOnOneShotAnim = false;
        if (!this.isScreenOrientationHasLocked) {
          SCBScreenSessionManager.getInstance().setScreenOrientationLocked(false);
        }
        TraceUtil.endAnimTrace(DomainName.KG, prepare.mainAnimScene);
      }
    };
    this.addAnimListener(prepare.mainAnimScene, listener);

    let delay = this.getAnimationEndDelay(oneShotAnimScene);
    setTimeout(()=>{
      listener.onAnimationEnd?.();
    }, delay)

    return listener;
  }

  protected sendMessageToUnlock(oneShotAnimScene: string) {
    log.showInfo(`sendMessageToUnlock for ${oneShotAnimScene}`)
    switch (oneShotAnimScene) {
      case ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION:
        sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_UNLOCKING, null));
        break;
      case ScreenLockToDesktopConsts.KEYPRESS_TO_DESKTOP_CLOCK_ANIMATION:
        sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.KEYPRESS_TO_DESKTOP_UNLOCKING, null));
        break;
      case ScreenLockToDesktopConsts.FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION:
        sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.FINGERPRINT_TO_DESKTOP_UNLOCKING,
          null));
        break;
      case ScreenLockToDesktopConsts.FACE_TO_DESKTOP_CLOCK_ANIMATION:
        sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.FACE_TO_DESKTOP_UNLOCKING, null));
        break;
      case ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION:
      case ClockOneShortConsts.PART_AOD_TO_DESKTOP_CLOCK_ANIMATION:
        sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.AOD_TO_DESKTOP_UNLOCKING, null));
        break;
      default:
        break;
    }
  }

  public prepareForOneShotAnimOnFirstMove(param: ClockAnimParam): void {
    // 在触发跟手滑动的第一个move事件，做准备工作
    log.showInfo(`oneShot call prepareForOneShotAnimOnFirstMove`)
    this.prepareAnimPrepareParam = this.getAnimPrepareParam(param);
    TraceUtil.startAnimTrace(DomainName.KG, this.prepareAnimPrepareParam.mainAnimScene);
    this.prepareAnimPrepareParam.animListener?.onAnimationStart?.(); // 动效开启回调

    this.prepareForSeparatorSuccess = this.prepareForSeparatorAlphaAnimOnFirstMove(this.prepareAnimPrepareParam);
    if (this.prepareForSeparatorSuccess) {
      this.endLineAlpha = this.initLineAlphaAnimForOneShot(this.prepareAnimPrepareParam,
        ScreenLockToDesktopConsts.SLIDE_MOVE_CLOCK_ANIMATION);
      this.endPointAlpha = this.initPointAlphaAnimForOneShot(this.prepareAnimPrepareParam,
        ScreenLockToDesktopConsts.SLIDE_MOVE_CLOCK_ANIMATION);
    }
    this.clockStaticState.updateClockRectInfo();
    this.clockStaticState.updatePageDesktopClockRectInfo();
  }

  private prepareForSeparatorAlphaAnimOnFirstMove(prepare: AnimPrepareParam): boolean {
    if (!prepare.isPreSeparateShow && !prepare.isCurSeparateShow) { // 分割符始终不可见，不涉及动效
      return false;
    }
    if (prepare.isPreSeparateShow && prepare.isCurSeparateShow &&
      prepare.isPreSeparateLine === prepare.isCurSeparateLine) { // 分割符可见且无切换，不涉及动效
      return false;
    }
    return true;
  }

  /**
   * 开启时钟元素收起、展开状态切换动效
   *
   * @param param 动效入参
   */
  public startCollapseStateChangeAnimOnMoveForOneShot(isAnimToExpand: boolean, slidingDistance: number): void {
    if (!this.clockStaticState.getCurElementConf()) {
      log.showWarn(`oneShot startCollapseStateChangeAnimOnMoveForOneShot invalid param: ${isAnimToExpand}`)
      return;
    }

    let clockAnimationProgress = slidingDistance / ONESHOT_ANIM_MAX_SLIDING_DISTANCE * CLOCK_ANI_PROGRESS_SCALE;
    clockAnimationProgress = clockAnimationProgress > MAX_CLOCK_ANIMATION_PROGRESS ?
      MAX_CLOCK_ANIMATION_PROGRESS : clockAnimationProgress;

    this.startAllElementAnimOnMove(this.prepareAnimPrepareParam, clockAnimationProgress); // 全元素统一过渡动效
    this.lastMoveProgress = clockAnimationProgress;
  }

  private startAllElementAnimOnMove(prepare: AnimPrepareParam, progress: number): void {
    log.showInfo(`'oneShot call startAllElementAnimOnMove start prepare.isTimeSeparate = ${prepare.isTimeSeparate}`)
    let sourceElementConf = this.clockStaticState.getPreElementConf();
    let targetElementConf = this.clockStaticState.getCurElementConf();
    if (prepare.isTimeSeparate) { // 离散小时、分钟类型
      let isCollapse = this.isAnimCollapse(prepare);
      let firstLineStartProgress = isCollapse ? ANIM_MIN_VALUE : TIME_START_PROGRESS; // 第一行展开时delay
      let otherStartProgress = isCollapse ? TIME_START_PROGRESS : ANIM_MIN_VALUE; // 其他行收起时delay

      let firstLineCurProgress = (progress > firstLineStartProgress) ? (progress - firstLineStartProgress) : 0;
      this.updateElementWithProgress(firstLineCurProgress, sourceElementConf, targetElementConf, TIME_FIRST_LINE);

      let otherCurProgress = (progress > otherStartProgress) ? (progress - otherStartProgress) : 0;
      this.updateClockGridParamWithProgress(otherCurProgress);
      this.updateNoTimeViewOpacityWithProgress(otherCurProgress);
      this.updateElementWithProgress(otherCurProgress, sourceElementConf, targetElementConf, OTHER_LINE);
      this.updateClockOffsetWithProgress(otherCurProgress, true);
      log.showInfo(`'oneShot call startAllElementAnimOnMove end`)
      return;
    }

    this.updateClockGridParamWithProgress(progress);
    this.updateNoTimeViewOpacityWithProgress(progress);
    this.updateElementWithProgress(progress, sourceElementConf, targetElementConf);
    this.updateClockOffsetWithProgress(progress, true);
    log.showInfo(`'oneShot call startAllElementAnimOnMove end`)
  }

  private updateElementWithProgress(progress: number, sourceConf?: ElementConf[], targetConf?: ElementConf[],
    indexes?: number[]): void {
    if (indexes) { // 分散更新
      indexes.forEach((index) => {
        clockLayoutParam.updateSingleElementWithProgress(progress, sourceConf?.[index], targetConf?.[index],
          FontSizeKeyHelper.getIsKeepFontSize());
      });
      return;
    }
    // 统一更新
    clockLayoutParam.updateElementConfigWithProgress(progress, sourceConf, targetConf,
      FontSizeKeyHelper.getIsKeepFontSize());
  }

  private updateClockGridParamWithProgress(progress: number): void {
    clockLayoutParam.updateGridParamWithProgress(progress, this.clockStaticState.getPreGrid(),
      this.clockStaticState.getCurGrid());
    let sourceMargins = this.clockStaticState.getClockViewMargin(ClockStaticData.sIsClockWidgetExpand);
    let targetMargins = this.clockStaticState.getClockViewMargin(!this.clockStaticState.isClockToCollapseOnDesktop);
    this.clockStaticState.clockMarginLeft = sourceMargins[0] + (targetMargins[0] - sourceMargins[0]) * progress;
    this.clockStaticState.clockMarginTop = sourceMargins[1] + (targetMargins[1] - sourceMargins[1]) * progress;
    this.clockBindState.clockMarginLeft = this.clockStaticState.clockMarginLeft;
    this.clockBindState.clockMarginTop = this.clockStaticState.clockMarginTop;
  }

  private updateNoTimeViewOpacityWithProgress(progress: number): void {
    let curProgress = progress * NO_TIME_ANI_PROGRESS_SCALE;
    curProgress = curProgress > MAX_CLOCK_ANIMATION_PROGRESS ? MAX_CLOCK_ANIMATION_PROGRESS : curProgress;
    let sourceNoTimeViewOpacity =
      this.clockStaticState.getNoTimeViewOpacity(!this.clockStaticState.isClockToCollapseOnDesktop);
    let targetNoTimeViewOpacity =
      this.clockStaticState.getNoTimeViewOpacity(this.clockStaticState.isClockToCollapseOnDesktop);
    this.clockStaticState.noTimeViewOpacity = sourceNoTimeViewOpacity +
      (targetNoTimeViewOpacity - sourceNoTimeViewOpacity) * curProgress;
    this.clockBindState.noTimeViewOpacity = this.clockStaticState.noTimeViewOpacity;
  }

  private updateClockOffsetWithProgress(progress: number, useOldClockRectInfo?: boolean): void {
    let sourceClockOffset = this.clockStaticState.getClockOffset(!this.clockStaticState.isClockToCollapseOnDesktop,
      useOldClockRectInfo);
    let targetClockOffset = this.clockStaticState.getClockOffset(this.clockStaticState.isClockToCollapseOnDesktop,
      useOldClockRectInfo);
    this.clockStaticState.clockOffsetX = sourceClockOffset[0] +
      (targetClockOffset[0] - sourceClockOffset[0]) * progress;
    this.clockStaticState.clockOffsetY = sourceClockOffset[1] +
      (targetClockOffset[1] - sourceClockOffset[1]) * progress;
    this.clockBindState.clockOffsetX = this.clockStaticState.clockOffsetX;
    this.clockBindState.clockOffsetY = this.clockStaticState.clockOffsetY;
  }

  public startClockFontSizeAnimOnUpForOneShot(param: ClockAnimParam, vel: number): void {
    if (!this.clockStaticState.getCurElementConf()) {
      log.showWarn(`startClockMoveAnimOnUpForOneShot invalid param: ${param.isAnimToExpand}`)
      return;
    }

    animateTo(
      {
        duration: FONTSIZE_ANI_DURATION,
        curve: curves.springCurve(vel, 1, 329, 34),
      },
      () => {
        this.updateFontSizeAfterSlideUp();
      }
    )
  }

  public startCollapseStateChangeAnimOnUpForOneShot(param: ClockAnimParam, vel: number): void {
    log.showInfo('oneShot call startCollapseStateChangeAnimOnUpForOneShot start');
    if (!this.clockStaticState.getCurElementConf()) {
      log.showWarn(`startCollapseStateChangeAnimOnUpForOneShot invalid param: ${param.isAnimToExpand}`)
      return;
    }

    log.showInfo(`oneShot desktopClockFontSize=${this.getDesktopClockFontSize()}`)
    this.startAllElementAndSeparatorAlphaAnimOnUp(this.prepareAnimPrepareParam, vel); // 全元素统一过渡动效&分隔符alpha动效
    log.showInfo('oneShot call startCollapseStateChangeAnimOnUpForOneShot end');
  }

  private startAllElementAndSeparatorAlphaAnimOnUp(prepare: AnimPrepareParam, vel: number): void {
    log.showInfo(`oneShot startAllElementAndSeparatorAlphaAnimOnUp
      start prepare.isTimeSeparate = ${prepare.isTimeSeparate}`)
    let targetElementConf = this.clockStaticState.getCurElementConf();
    if (prepare.isTimeSeparate) { // 离散小时、分钟类型
      log.showInfo(`oneShot call createSeparateAnimateToOnUp`)
      this.createSeparateAnimateToOnUp(prepare, targetElementConf, vel);
      return;
    }
    // 统一动效
    log.showInfo(`oneShot call createUnitAnimateToOnUp`);
    this.createUnitAnimateToOnUp(targetElementConf, prepare, vel);
  }

  /**
   * 更新时钟元素参数
   *
   * @param keepFontSize 是否保留原始字号
   * @param newConf 参数集
   * @param indexes 更新元素索引
   */
  protected updateElementForOneShot(keepFontSize: boolean, newConf?: ElementConf[], indexes?: number[]): void {
    if (indexes) { // 分散更新
      indexes.forEach((index) => {
        clockLayoutParam.updateSingleElement(newConf?.[index], keepFontSize, true);
      });
      return;
    }
    // 统一更新
    clockLayoutParam.updateElementConfig(newConf, keepFontSize, true);
  }

  private createUnitAnimateToOnUp(targetElementConf: ElementConf[] | undefined, prepare: AnimPrepareParam,
    vel: number) {
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.MAIN_SPRING, vel), 0, undefined,
      () => {
        this.updateClockGridParam();
        this.updateClockOffset(true);
        this.updateNoTimeViewOpacity();
        this.updateTimeViewOpacity();
        this.updateTextColor();
        this.updateElementForOneShot(true, targetElementConf);
        this.updateTextOffSets();
        this.updateScaleOptions();
        if (this.prepareForSeparatorSuccess) {
          if (this.clockAnimData.lineSeparatorAnimating) {
            this.clockAnimData.setLineSeparatorAlpha(this.endLineAlpha);
          }
          if (this.clockAnimData.pointSeparatorAnimating) {
            this.clockAnimData.setPointSeparatorAlpha(this.endPointAlpha);
          }
        }
      }, this.getMainSpringAnimListenerForOneShot(prepare,
        ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION));
  }

  private createSeparateAnimateToOnUp(prepare: AnimPrepareParam, targetElementConf: ElementConf[] | undefined,
    vel: number) {
    let isCollapse = this.isAnimCollapse(prepare);
    let firstLineDelay = isCollapse ? ANIM_MIN_VALUE : TIME_SPRING_DELAY; // 第一行展开时delay
    let otherDelay = isCollapse ? TIME_SPRING_DELAY : ANIM_MIN_VALUE; // 其他行收起时delay
    let firstLineProgress = isCollapse ? ANIM_MIN_VALUE : TIME_START_PROGRESS;
    let otherProgress = isCollapse ? TIME_START_PROGRESS : ANIM_MIN_VALUE;
    if (this.lastMoveProgress < firstLineProgress) {
      firstLineDelay = (firstLineProgress - this.lastMoveProgress) / firstLineProgress * firstLineDelay;
    } else {
      firstLineDelay = ANIM_MIN_VALUE;
    }
    if (this.lastMoveProgress < otherProgress) {
      otherDelay = (otherProgress - this.lastMoveProgress) / otherProgress * otherDelay;
    } else {
      otherDelay = ANIM_MIN_VALUE;
    }
    log.showInfo(`oneShot startAllElementAndSeparatorAlphaAnimOnUp firstLineDelay
          = ${firstLineDelay} otherDelay = ${otherDelay}`);
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.MAIN_SPRING, vel), firstLineDelay,
      undefined,
      () => {
        this.updateElementForOneShot(true, targetElementConf, TIME_FIRST_LINE);
      }, isCollapse ? undefined : this.getMainSpringAnimListenerForOneShot(prepare,
        ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION));
    CommonAnimationUtil.createAnimateToImmediately(this.getAnimCurve(AnimParamType.MAIN_SPRING, vel), otherDelay,
      undefined,
      () => {
        this.updateClockGridParam();
        this.updateClockOffset(true);
        this.updateNoTimeViewOpacity();
        this.updateTimeViewOpacity();
        this.updateTextColor();
        this.updateElementForOneShot(true, targetElementConf, OTHER_LINE);
        this.updateTextOffSets();
        this.updateScaleOptions();
        if (this.prepareForSeparatorSuccess) {
          if (this.clockAnimData.lineSeparatorAnimating) {
            this.clockAnimData.setLineSeparatorAlpha(this.endLineAlpha);
          }
          if (this.clockAnimData.pointSeparatorAnimating) {
            this.clockAnimData.setPointSeparatorAlpha(this.endPointAlpha);
          }
        }
      }, isCollapse ? this.getMainSpringAnimListenerForOneShot(prepare,
        ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION) : undefined);
  }

  private updateHourFontSize(tarFontSize: number, isScale: boolean = false) {
    clockLayoutParam.updateHourFontSize(tarFontSize, isScale);
  }

  private updateMinuteAndSeparatorFontSize(tarFontSize: number, isScale: boolean = false) {
    clockLayoutParam.updateMinuteAndSeparatorFontSize(tarFontSize, isScale);
  }

  private updateHourMinuteAndSeparatorFontSize(tarFontSize: number, isScale: boolean = false) {
    this.updateHourFontSize(tarFontSize, isScale);
    this.updateMinuteAndSeparatorFontSize(tarFontSize, isScale);
  }

  public stopOneShotAnim(): void {
    // 打断已有动效
    this.interceptAnimScene(AnimScene.SCENE_MAIN_COLLAPSE);
    this.interceptAnimScene(AnimScene.SCENE_MAIN_EXPAND);
  }

  protected getAnimCurve(animType: AnimParamType, vel: number = 0): ICurve | Curve {
    switch (animType) {
      case AnimParamType.MAIN_SPRING:
        return curves.interpolatingSpring(vel, 1, 329, 34);
      case AnimParamType.SECONDARY_CUBIC_BEZIER:
        return curves.cubicBezierCurve(0.4, 0, 0.4, 1);
      case AnimParamType.DESKTOP_AOD_SPRING:
        return curves.interpolatingSpring(vel, 1, 228, 30);
      default :
        return Curve.Linear;
    }
  }

  public setClockToCollapse(): void {
    this.clockStaticState.updateClockToCollapseOnDesktop(true);
    this.updateClockGridParam();
    this.updateElementForOneShot(true, this.clockStaticState.getCurElementConf());
    this.updateClockOffset();
    this.updateNoTimeViewOpacity();
    this.updateTimeViewOpacity();
    this.updateTextColor();
    this.updateTextOffSets();
    this.updateScaleOptions();
    this.updateHourMinuteAndSeparatorFontSize(this.getDesktopClockFontSize(), true);
    this.clockStaticState.updateClockToCollapseOnDesktop(false);
  }

  protected getAnimationEndDelay(oneShotAnimScene: string): number {
    const timeoutDelay: number | undefined = ANIM_TIMEOUT_TIME.get(oneShotAnimScene);
    if (timeoutDelay) {
      return timeoutDelay;
    }
    return CALL_ANIMATION_END_DELAY;
  }

  protected refreshClockParamInAnim(keepFontSize: boolean, newConf?: ElementConf[], indexes?: number[]): void {
    this.refreshClockParamUnlessOffset(keepFontSize, newConf, indexes);
    this.updateClockOffset();
  }

  protected refreshClockParamUnlessOffset(keepFontSize: boolean, newConf?: ElementConf[], indexes?: number[]): void {
    this.updateElementForOneShot(keepFontSize, newConf, indexes);
    this.updateTimeViewOpacity();
    this.updateTextColor();
    this.updateTextOffSets();
    this.updateScaleOptions();
  }

  protected getDesktopClockFontSize(): number {
    let originFontSize =
      DESKTOP_CLOCK_FONT_SIZE;
    return UDFontAdapterUtil.getDesktopClockFontSize(originFontSize);
  }

  private getTargetClockFontSize(): number {
    if (this.clockStaticState.isClockToCollapseOnDesktop) {
      return this.getDesktopClockFontSize();
    } else {
      return this.clockStaticState.getScreenLockTimeFontSize();
    }
  }
}