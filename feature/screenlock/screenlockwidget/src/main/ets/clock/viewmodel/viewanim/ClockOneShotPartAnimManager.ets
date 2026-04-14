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

import { LogDomain, DomainName, TraceUtil, Logger, RectInfo } from '@ohos/basicutils';
import { ClockOneShortConsts } from '@ohos/screenlockcommon';
import { AnimationStateListener, CommonAnimationUtil } from '../../../common/utils/AnimationUtil';
import { ClockLayout, ClockWidgetId } from '../../../common/WidgetParam';
import { clockWidgetConfigManager } from '../../common/ClockWidgetConfigManager';
import { clockLayoutParam, ElementConf, ClockLayoutCopyUtil, ClockGridParam } from '../../common/ClockLayoutParam';
import {
  AnimParamType,
  AnimPrepareParam,
  AnimScene,
  ClockAnimParam,
  OTHER_LINE,
  TIME_FIRST_LINE,
} from './ClockWidgetAnimManager'

import { ClockWidgetOneShotAnimManager } from './ClockWidgetOneShotAnimManager';
import { DateWeekLunarStyle } from '../../common/ClockConstants';
import { slStateHelper } from '../../../common/utils/SlStateHelper';
import { SlClockBindState } from '../../model/data/SlClockBindState';
import { HashMap } from '@kit.ArkTS';
import { AnimMgr, AnimParamWrap } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/manager/AnimMgr';

const DATE_ALPHA_DURATION = 150; // 日期透明度动效时长
const DESKTOP_TO_PART_AOD_TIME_SPRING_DELAY = 50;
const DATE_ALPHA_DELAY = 20;

const TAG = 'ClockOneShotPartAnimManager';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

const TIME_SET: Set<String> = new Set(
  [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1,
    ClockWidgetId.ID_SEPARATOR, ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1]);

interface ClockShotAnimParam {
  curve: Curve | ICurve,
  delay: number,
  duration?: number | undefined,
  callback: Function,
  listener?: AnimationStateListener
}

/**
 * 局部时钟一镜到底动效控制
 */
export class ClockOneShotPartAnimManager extends ClockWidgetOneShotAnimManager {
  private animMgr: AnimMgr = new AnimMgr(TAG);
  private animListenerMap: HashMap<string, AnimationStateListener> = new HashMap();
  private timeoutMap: HashMap<string, Nullable<number>> = new HashMap();

  /**
   * 桌面到局部AOD动效
   * @param param ClockAnimParam
   * @param oneShotAnimScene oneShotAnimScene
   */
  public startClockAnimDesktop2PartAodOneShot(param: ClockAnimParam, oneShotAnimScene: string): void {
    log.showInfo(TAG, 'oneShot startClockAnimDesktop2PartAodOneShot');
    let prepare = this.prepareAnim(param);
    if (!prepare) {
      return;
    }
    prepare.isPowerOff = true;
    prepare.fontDaley = 0;

    this.startSeparatorAlphaAnimForOneShot(prepare, oneShotAnimScene); // 分隔符alpha动效
    let elementConf: ElementConf[] | undefined = this.clockStaticState.getExpandAodElementConf();
    // 刷新动效第一帧
    const deskTopFontSize: number = this.getDesktopClockFontSize();

    this.updatePartClockOffset(false);
    clockLayoutParam.updateElementConfig(this.createFontSizeAnimParam(elementConf, deskTopFontSize));

    const finishCallback: () => void = () => {
      log.showInfo(TAG, 'Desktop2PartAod onFinish');
      this.clockStaticState.updateClockToCollapseOnDesktop(false);
      // 刷新UI
      this.updateComPartParam(elementConf);
      this.updateNoTimeViewOpacity();
      this.updatePartDateWeekLunarStyle(true);
      this.updatePartClockOffset(true);

      const slClockBindCtrl = slStateHelper.getSlClockBindState();
      slClockBindCtrl?.setClockDesktopToAod(false);
    }
    let listener = this.createAnimFinishListener(prepare?.animListener, finishCallback, oneShotAnimScene);
    prepare.elemConfig = elementConf;
    if (prepare.isTimeSeparate) {
      this.playDesktop2AodSeparateAnim(elementConf, oneShotAnimScene, listener);
      return;
    }
    this.playDesktopAndPartAodUnitAnim(elementConf, prepare, oneShotAnimScene, listener);
  }

  /**
   * 创建动效回调监听器
   * @param childListener 子监听器
   * @param otherFinish 其他需要回调处理事情
   * @param oneShotAnimScene 场景
   */
  private createAnimFinishListener(childListener: AnimationStateListener | undefined,
    otherFinish: () => void, oneShotAnimScene: string): AnimationStateListener {
    const animationStateListener: AnimationStateListener = {
      onAnimationStart: () => {
      },
      onAnimationEnd: () => {
        // 动效正常回调清除超时监听
        const lastTimerId = this.timeoutMap.get(oneShotAnimScene);
        if (lastTimerId !== undefined) {
          clearTimeout(lastTimerId);
          this.timeoutMap.set(oneShotAnimScene, undefined);
        }
        otherFinish?.();
        childListener?.onAnimationEnd?.();
      }
    }
    this.animListenerMap.set(oneShotAnimScene, animationStateListener);

    // 防止动效不回掉,需要设置超时监听。
    const lastTimerId = this.timeoutMap.get(oneShotAnimScene);
    if (lastTimerId !== undefined) {
      // 上一次同一个场景动效还未回调，这一次需要清除回调
      clearTimeout(lastTimerId);
      this.timeoutMap.set(oneShotAnimScene, undefined);
    }

    let delay = this.getAnimationEndDelay(oneShotAnimScene);
    const timerId = setTimeout(() => {
      log.showWarn(TAG, 'anim onfinish timeout, call onAnimationEnd');
      animationStateListener.onAnimationEnd?.();
    }, delay);
    this.timeoutMap.set(oneShotAnimScene, timerId);
    return animationStateListener;
  }

  public playDesktop2AodSeparateAnim(elementConf: ElementConf[] | undefined, oneShortScene: string,
    listener: AnimationStateListener): void {
    log.showInfo(TAG, 'oneShot playDesktop2AodSeparateAnim');
    const curve: ICurve | Curve = this.getAnimCurve(AnimParamType.DESKTOP_AOD_SPRING, 0);
    // 主动效
    let hourParam: AnimParamWrap = {
      mainScene: oneShortScene,
      oriParam: {
        curve: curve,
        delay: DESKTOP_TO_PART_AOD_TIME_SPRING_DELAY,
        onFinish: () => {
          listener.onAnimationEnd?.();
        }
      },
      oriEvent: () => {
        this.updateClockGridParam();
        this.updateElementForOneShot(true, elementConf, TIME_FIRST_LINE);
        this.updateTimeViewOpacity();
        this.updateTextColor();
        this.updateTextOffSets();
        this.updateScaleOptions();
        this.updateClockOffset();
        this.updatePartClockOffset(true);
      },
    };
    // 子动效
    let minuteParam: AnimParamWrap = {
      // 动效场景，主要标识
      mainScene: oneShortScene,
      // 动效参数
      oriParam: {
        curve: curve,
        delay: 0,
      },
      // 动效执行事件
      oriEvent: () => {
        this.updateElementForOneShot(true, elementConf, OTHER_LINE);
      },
    };

    this.playAllSeparateAnim(hourParam, minuteParam, true, oneShortScene);
  }

  private playAodToDesktopSeparateAnim(elementConf: ElementConf[] | undefined,
    oneShortScene: string, listener: AnimationStateListener): void {
    const curve: ICurve | Curve = this.getAnimCurve(AnimParamType.DESKTOP_AOD_SPRING, 0);
    // 主动效
    let minuteParam: AnimParamWrap = {
      mainScene: oneShortScene,
      oriParam: {
        curve: curve,
        delay: 50,
        onFinish: () => {
          listener.onAnimationEnd?.();
        }
      },
      oriEvent: () => {
        this.updateComPartParam(elementConf);
        this.updateTextOffSets();
      },
    };

    // 子动效
    let hourParam: AnimParamWrap = {
      mainScene: oneShortScene,
      oriParam: {
        curve: curve,
        delay: 0,
      },
      oriEvent: () => {
        this.updateElementForOneShot(true, elementConf, TIME_FIRST_LINE);
      },
    };
    this.playAllSeparateAnim(minuteParam, hourParam, false, oneShortScene);
  }

  private playAllSeparateAnim(mainParam: AnimParamWrap,
    secondParam: AnimParamWrap, isPowerOff: boolean, oneShortScene: string): void {
    this.animMgr.animateToImmediately(mainParam);
    this.animMgr.animateToImmediatelySecondary(secondParam);
    // 子动效
    let otherParam: AnimParamWrap = {
      mainScene: oneShortScene,
      oriParam: {
        curve: this.getAnimCurve(AnimParamType.SECONDARY_CUBIC_BEZIER, 0),
        delay: DATE_ALPHA_DELAY,
        duration: DATE_ALPHA_DURATION,
      },
      oriEvent: () => {
        this.updatePartDateWeekLunarStyle(isPowerOff);
        this.updateNoTimeViewOpacity();
      },
    };
    this.animMgr.animateToImmediatelySecondary(otherParam);
  }

  public playDesktopAndPartAodUnitAnim(elementConf: ElementConf[] | undefined,
    prepare: AnimPrepareParam, oneShortScene: string, listener: AnimationStateListener): void {
    log.showInfo(TAG, 'oneShot playDesktopAndPartAodUnitAnim');
    // 主动效
    let hourParam: AnimParamWrap = {
      mainScene: oneShortScene,
      oriParam: {
        curve: this.getAnimCurve(AnimParamType.DESKTOP_AOD_SPRING, 0),
        delay: 0,
        onFinish: () => {
          listener.onAnimationEnd?.();
        }
      },
      oriEvent: () => {
        this.updateComPartParam(elementConf);
        this.updateTextOffSets();
        this.updateTextOffSets();
        if (prepare.isPowerOff) {
          this.updatePartClockOffset(true);
        }
      },
    };
    this.animMgr.animateToImmediately(hourParam);

    // 子动效
    let otherParam: AnimParamWrap = {
      // 动效场景，主要标识
      mainScene: oneShortScene,
      // 动效参数
      oriParam: {
        curve: this.getAnimCurve(AnimParamType.SECONDARY_CUBIC_BEZIER, 0),
        delay: 0,
        duration: DATE_ALPHA_DURATION,
      },
      // 动效执行事件
      oriEvent: () => {
        this.updateNoTimeViewOpacity();
        this.updatePartDateWeekLunarStyle(prepare.isPowerOff ?? false);
      },
    };
    this.animMgr.animateToImmediatelySecondary(otherParam);
  }

  /**
   * 准备从桌面灭屏，锁屏第一帧参数
   * @param srcConf 源参数配置
   * @param destConf 目标参数
   * @returns 目标参数配置
   */
  public createFontSizeAnimParam(srcConf: ElementConf[] | undefined, destConf: number): ElementConf[] {
    let newArr: ElementConf[] = [];
    if (!srcConf) {
      return [];
    }
    let logStr = '';
    srcConf.forEach(elem => {
      const newConfig: ElementConf | undefined = ClockLayoutCopyUtil.copyElement(elem);
      if (newConfig) {
        if (TIME_SET.has(elem.id)) {
          const srcFontSize = elem.fontSize * this.clockStaticState.displayScale;
          newConfig.fontSizeScale = destConf / srcFontSize;
          logStr = `oldFontscale:${elem.fontSizeScale},newFontScale:${newConfig.fontSizeScale},` +
            `fontSize: ${elem.fontSize},srcFontSize:${srcFontSize},destFontSize: ${destConf},`;
        }
        newArr.push(newConfig);
      }
    });
    log.showInfo(TAG, logStr);
    return newArr;
  }

  /**
   * 局部AOD到桌面动效
   * @param param ClockAnimParam
   * @param oneShotAnimScene oneShotAnimScene
   */
  public startClockAnimPartAod2DesktopOneShot(param: ClockAnimParam, oneShotAnimScene: string): void {
    log.showInfo(TAG, 'oneShot startClockAnimPartAod2DesktopOneShot');
    let prepare = this.prepareAnim(param);
    if (!prepare) {
      return;
    }
    prepare.isPowerOff = false;
    prepare.fontDaley = 0;

    this.startSeparatorAlphaAnimForOneShot(prepare, oneShotAnimScene); // 分隔符alpha动效
    const deskTopFontSize: number = this.getDesktopClockFontSize();
    const animFinishConf: ElementConf[] =
      this.createFontSizeAnimParam(this.clockStaticState.getCurElementConf(), deskTopFontSize);

    let finishFontSize: number = deskTopFontSize;
    if (animFinishConf && animFinishConf.length > 0) {
      finishFontSize = animFinishConf[0].fontSize;
    }
    let aodElementConf: ElementConf[] | undefined = this.clockStaticState.getExpandAodElementConf();
    let animStartConf: ElementConf[] = [];
    aodElementConf?.forEach(elem => {
      const newConfig: ElementConf | undefined = ClockLayoutCopyUtil.copyElement(elem);
      if (newConfig) {
        if (TIME_SET.has(elem.id)) {
          newConfig.fontSizeScale = elem.fontSize * (elem.fontSizeScale ?? 1) / finishFontSize;
          newConfig.fontSize = finishFontSize;
        }
        animStartConf.push(newConfig);
      }
    });

    // 刷新动效前第一帧
    clockLayoutParam.updateElementConfig(animStartConf);

    const finishCallback: () => void = () => {
      log.showInfo(TAG, 'AodToDesktop onFinish');
      // 通知一镜到底监听完成
      const slClockBindCtrl = slStateHelper.getSlClockBindState();
      slClockBindCtrl?.setClockExpandOnAodAnim(false);
      // 刷新UI
      this.sendMessageToUnlock(ClockOneShortConsts.PART_AOD_TO_DESKTOP_CLOCK_ANIMATION);
    }
    const listener = this.createAnimFinishListener(prepare.animListener, finishCallback, oneShotAnimScene);

    prepare.elemConfig = animFinishConf;
    if (prepare.isTimeSeparate) {
      this.playAodToDesktopSeparateAnim(animFinishConf, oneShotAnimScene, listener);
      return;
    }
    this.playDesktopAndPartAodUnitAnim(animFinishConf, prepare, oneShotAnimScene, listener);
  }

  public updatePartClockOffset(isPowerOff: boolean): void {
    const slClockBindCtrl: SlClockBindState | undefined = slStateHelper.getSlClockBindState();
    let offset: Nullable<Margin> = clockWidgetConfigManager.getAodClockMarginByType(this.clockStaticState.clockLayout ??
    ClockLayout.DEFAULT_CLOCK_LAYOUT);
    let clockLeftMargin = slClockBindCtrl?.getClockWidgetLeftMargin() ?? 0;
    let clockTopMargin = slClockBindCtrl?.getClockWidgetTopMargin() ?? 0;
    if (!offset) {
      slClockBindCtrl?.setClockViewOffset({ x: clockLeftMargin, y: clockTopMargin });
      log.showWarn(TAG, 'updatePartClockOffset failed');
      return;
    }
    log.showInfo(TAG,
      `clockLeftMargin x:${clockLeftMargin}, clockTopMargin:${clockTopMargin},clockOffsetX:${
      offset.left},clockOffsetY:${offset.top}, isPowerOff:${isPowerOff}`);
    if (!isPowerOff) {
      slClockBindCtrl?.setClockViewOffset({ x: clockLeftMargin, y: clockTopMargin });
      return;
    }
    slClockBindCtrl?.setClockViewOffset({ x: offset.left, y: offset.top });
  }

  /**
   * 局部AOD到锁屏动效
   * @param param ClockAnimParam
   * @param oneShotAnimScene oneShotAnimScene
   */
  public startClockAnimPartAod2SlOneShot(param: ClockAnimParam, oneShotAnimScene: string): void {
    log.showInfo(TAG, 'startClockAnimPartAod2SlOneShot');
    let prepare = this.prepareAnim(param);
    if (!prepare) {
      return;
    }

    this.clockStaticState.updateGridAndElementConf();
    const dstConf: ElementConf[] | undefined = this.clockStaticState.getCurElementConf();
    const srcConf: ElementConf[] | undefined = this.clockStaticState.getExpandAodElementConf();
    // 刷新动效第一帧
    clockLayoutParam.updateElementConfig(this.createSlAndAodStartAnimParam(dstConf, srcConf));
    this.updatePartClockOffset(true);

    this.startSeparatorAlphaAnimForOneShot(prepare, oneShotAnimScene); // 分隔符alpha动效
    prepare.isPowerOff = false;
    this.playSlAndAodAllAnim(dstConf, prepare, oneShotAnimScene); // 全元素统一过渡动效
  }

  /**
   * 优化性能，避免嵌套循环
   * @param confArr 时钟参数数组
   * @returns 时钟参数Map
   */
  private convertConfArray2Map(confArr: ElementConf[] | undefined): HashMap<string, ElementConf> {
    const confMap: HashMap<string, ElementConf> = new HashMap();
    if (!confArr) {
      return confMap;
    }
    confArr?.forEach(e => {
      confMap.set(e.id, e);
    });
    return confMap;
  }

  /**
   * 准备时钟动效首帧，中心思想是动效过程中只能通过fontScale来实现，而不是去更改字体
   * 需要把更改当前的fontSize到目标fontSize，为保证显示效果不变，调整fontScale
   * 计算规格如下
   *                 srcFontSize * srcFontScale
   * newFontScale = ----------------------------
   *                        destFontSize
   * newFontSize = destFontSize
   *
   * 如：当前时钟字体大小是120,字体缩放为0.5，动效后时钟大小是80,
   * newFontScale = (120 * 0.5) / 80 = 0.75
   * newFontSize = 80
   *
   * @param dstConf 目标参数: 动效终态
   * @param srcConf 当前参数：
   * @returns 动效首帧参数
   */
  public createSlAndAodStartAnimParam(dstConf: ElementConf[] | undefined,
    srcConf: ElementConf[] | undefined): ElementConf[] {
    if (!dstConf || !srcConf) {
      return [];
    }
    const destConfMap: HashMap<string, ElementConf> = this.convertConfArray2Map(dstConf);
    let newArr: ElementConf[] = [];
    let logStr = '';
    srcConf.forEach(elem => {
      const newConfig: ElementConf | undefined = ClockLayoutCopyUtil.copyElement(elem);
      const destElem = destConfMap.get(elem.id);
      if (newConfig && destElem) {
        const destFontSize = destElem.fontSize;
        const srcFontSize = elem.fontSize * (elem.fontSizeScale ?? 1);
        newConfig.fontSizeScale = srcFontSize / destFontSize;
        newConfig.fontSize = destFontSize;
        if (elem.id === ClockWidgetId.ID_HOUR0 || elem.id === ClockWidgetId.ID_DATE ||
          elem.id === ClockWidgetId.ID_COM_SIGN) {
          logStr += `ID:${elem.id}, oldFontscale:${elem.fontSizeScale}, newFontScale:${newConfig.fontSizeScale},` +
            `srcFontSize:${elem.fontSize}, dstFontSize:${destFontSize},`;
        }
        newArr.push(newConfig);
      }
    });
    log.showInfo(TAG, logStr);
    return newArr;
  }

  /**
   * 锁屏到局部AOD动效
   * @param param ClockAnimParam
   * @param oneShotAnimScene oneShotAnimScene
   */
  public startClockAnimSl2PartAodOneShot(param: ClockAnimParam, oneShotAnimScene: string): void {
    log.showInfo(TAG, 'startClockAnimSl2PartAodOneShot');
    let prepare = this.prepareAnim(param);
    if (!prepare) {
      return;
    }

    this.clockStaticState.updateGridAndElementConf();
    // 目标参数
    let dstElementConf = this.clockStaticState.getExpandAodElementConf();
    // 当前参数
    let scrElementConf = this.clockStaticState.getCurElementConf();
    // 刷新第一帧
    clockLayoutParam.updateElementConfig(this.createSlAndAodStartAnimParam(dstElementConf, scrElementConf));
    this.updatePartClockOffset(false);

    this.startSeparatorAlphaAnimForOneShot(prepare, oneShotAnimScene); // 分隔符alpha动效
    prepare.isPowerOff = true;
    this.playSlAndAodAllAnim(dstElementConf, prepare, oneShotAnimScene); // 全元素统一过渡动效
  }

  private playSlAndAodAllAnim(elementConf: ElementConf[] | undefined, prepare: AnimPrepareParam,
    oneShotAnimScene: string): void {
    const finishCallback: () => void = () => {
      log.showInfo(TAG,  `${oneShotAnimScene} SlAndAod onFinish`);
      this.clockStaticState.updateGridAndElementConf();
      this.updateTimeViewOpacity();
      this.updateTextColor();
      this.updateTextOffSets();
      this.updateScaleOptions();
      this.updateClockPartAodParam(true, prepare.isPowerOff ?? false, elementConf);
      this.updateNoTimeViewOpacity();
    }
    const listener: AnimationStateListener =
      this.createAnimFinishListener(prepare.animListener, finishCallback, oneShotAnimScene);

    let allParam: AnimParamWrap = {
      mainScene: oneShotAnimScene,
      oriParam: {
        curve: this.getAnimCurve(AnimParamType.DESKTOP_AOD_SPRING, 0),
        delay: 0,
        onFinish: () => {
          listener.onAnimationEnd?.();
        }
      },
      oriEvent: () => {
        this.updateClockPartAodParam(true, prepare.isPowerOff ?? false, elementConf);
      },
    };
    this.animMgr.animateToImmediately(allParam);
  }

  /**
   * 一帧刷新时钟参数
   */
  public updateClockPartAodParam(keepFontSize: boolean, isPowerOff: boolean, elementConf?: ElementConf[]): void {
    this.updateClockGridParam();
    this.updateElementForOneShot(keepFontSize, elementConf);
    this.updateClockOffset();
    this.updatePartDateWeekLunarStyle(isPowerOff);
    this.updatePartClockOffset(isPowerOff);
  }

  public refreshClock2PartAod(): void {
    log.showInfo(TAG, 'refreshClock2PartAod');
    let elementConf = this.clockStaticState.getExpandAodElementConf();
    this.updateClockPartAodParam(false, true, elementConf);
  }

  public refreshClock2Sl(): void {
    log.showInfo(TAG, 'refreshClock2Sl');
    let elementConf = this.clockStaticState.getCurElementConf();
    this.updateClockPartAodParam(false, false, elementConf);
  }

  private prepareAnim(param: ClockAnimParam): Nullable<AnimPrepareParam> {
    log.showInfo(TAG, 'prepareAnim start');
    if (!this.clockStaticState.getCurElementConf()) {
      return undefined;
    }
    // 打断已有动效
    this.interceptAnimScene(AnimScene.SCENE_INTO_PART_AOD);
    this.interceptAnimScene(AnimScene.SCENE_EXIT_PART_AOD);
    let prepare = this.getAnimPrepareParam(param);
    prepare.mainAnimScene = param.isAnimToExpand ? AnimScene.SCENE_INTO_PART_AOD : AnimScene.SCENE_EXIT_PART_AOD;
    TraceUtil.startAnimTrace(DomainName.KG, prepare.mainAnimScene);
    prepare.animListener?.onAnimationStart?.(); // 动效开启回调
    return prepare;
  }

  private updateComPartParam(elementConf?: ElementConf[]): void {
    this.updateClockGridParam();
    this.updateElementForOneShot(true, elementConf);
    this.updateTimeViewOpacity();
    this.updateTextColor();
    this.updateScaleOptions();
    this.updateClockOffset();
  }

  public stopOneShotAnim(): void {
    // 打断已有动效
    log.showInfo(TAG, 'stopOneShotAnim all anim');
    this.animListenerMap.forEach((v, k) => {
      if (k) {
        this.animMgr.interruptAnim(k);
      }
    });
  }

  protected updatePartDateWeekLunarStyle(isAodClock: boolean): void {
    super.updateDateWeekLunarStyle();
    if (isAodClock) {
      const style: Nullable<DateWeekLunarStyle> =
        clockWidgetConfigManager.getAodClockMergeWeekLunar(this.clockStaticState.clockLayout ??
        ClockLayout.DEFAULT_CLOCK_LAYOUT);
      if (style) {
        this.clockStaticState.updatePartDateWeekLunarStyle(style);
        this.clockBindState.updatePartDateWeekLunarStyle(style);
      }
    }
  }

  /**
   * 更新时钟元素参数
   *
   * @param keepFontSize 是否保留原始字号
   * @param newConf 参数集
   * @param indexes 更新元素索引
   * @param keepTextAlign 是否保留对齐方式
   */
  protected updateElementForOneShot(keepFontSize: boolean,
    newConf?: ElementConf[], indexes?: number[], keepTextAlign?: boolean): void {
    if (indexes) { // 分散更新
      indexes.forEach((index) => {
        clockLayoutParam.updateSingleElement(newConf?.[index], keepFontSize, keepTextAlign);
      });
      return;
    }
    // 统一更新
    clockLayoutParam.updateElementConfig(newConf, keepFontSize, keepTextAlign);
  }
}