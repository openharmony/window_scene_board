/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { DeviceHelper, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';

const TAG = 'SCBSplitParam';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * split life cycle, ignore scene
 */
export enum SplitLifeCycle {

  /**
   * default
   */
  UNDEFINED,
  /**
   * between enter split hotarea end do one step animation finish
   */
  EXIT_FULLSCREEN_TO_ONESTEP,
  /**
   * after do one step animation finish
   */
  ONESTEP,
  /**
   * between secondary scene begin do turn to split animation end finish animation
   */
  EXIT_ONESTEP_TO_SPLIT,
  /**
   * after finish secondary scene turn to split animation
   */
  SPLIT,
  /**
   * between do split exit to one step animation end finish animation
   */
  EXIT_SPLIT_TO_ONESTEP,
  /**
   * between do one step exit to fullscreen animation end finish animation
   */
  EXIT_ONESTEP_TO_FUSCREEN,
  /**
   * between do exit split animation skip onestep end finish animation
   */
  EXIT_SPLIT_TO_FULLSCREEN,
  /**
   * between do exit split trun to float animation and finish animation
   */
  EXIT_SPLIT_TO_FLOATING,
  /**
   * between secondary scene begin do turn to mid scene animation end finish animation
   */
  EXIT_ONESTEP_TO_MIDSCENE,
  /**
   *
   */
  EXIT_SPLIT_TO_MIDSCENE,
  /**
   *
   */
  EXIT_MIDSCENE_TO_SPLIT,
}

/**
 * split window ratio type enum
 */
export enum SplitRatioEnum {
  /**
   * default 1:1
   */
  UNDEFINED = 0,
  /**
   * left(top):right(bottom) = 1:2
   */
  ONE_TO_TWO = 1,
  /**
   * left(top):right(bottom) = 2:1
   */
  TWO_TO_ONE = 2
}

/**
 * split ratio cache map key
 */
export enum SplitRatioCacheKey {
  /**
   * cache the split-ratio type of three-fold device
   */
  PREV_DIVIDER_RATIO,
  /**
   * cache the split-ratio type of three-fold device G mode
   */
  G_MODE_DIVIDER_RATIO,
  /**
   * cache the split-ratio type of pad
   */
  PAD_DIVIDER_RATIO
}

/**
 * split param
 */
@Observed
export class SCBSplitParam {
  /* ----- UI Attributes: Need { @Track } prefix--- */
  /**
   * whether show title bar
   */
  @Track public needShowTitleBar: boolean = true;

  /**
   * is need input method isNeedInputMethod
   */
  @Track public showInputMethodFlag: number = 1;

  /**
   * for floatToSplit to recognize whether in pre split state
   */
  @Track public isPreSplit: boolean = false;

  /**
   * weather display app icon for some gesture.
   */
  @Track public needShowIcon: boolean = false;

  /**
   * has avoid inputmethod
   */
  @Track hasAvoidInputMethod: boolean = false;

  /* ----- Not UI Attribute --- */
  /**
   * life cycle
   */
  private lifeCycle: SplitLifeCycle = SplitLifeCycle.UNDEFINED;

  /**
   * whether animate when exit one-step split
   */
  public oneStepExitNeedAnimation: boolean = true;

  /**
   * whether show exit split toast for folded
   */
  public needShowExitSplitToastForFolded: boolean = false;

  /**
   * needDelayRotation
   */
  private needDelayRotation: number = 0;

  /**
   * record the current rotation angle when touch events comes
   */
  public onTouchRotation: number = 0;

  /**
   * dragging one step anim break flag
   */
  public oneStepBreakFlag: boolean = false;

  /**
   * cache the split-ratio type
   */
  public splitRatioCacheMap: Map<SplitRatioCacheKey, SplitRatioEnum> = new Map();

  /**
   * delay when applying for title session
   */
  private _needDelayTitleAppear: boolean = true;

  /**
   * 三折叠产品，定制固定分屏比例的persistentId
   */
  public fixedSplitRatioPersistentId: number = 0;

  /**
   * 三折叠产品，应用定制固定分屏比例
   */
  public fixedSplitRatioType: SplitRatioEnum = SplitRatioEnum.UNDEFINED;

  /**
   * 三折叠产品，应用定制固定分屏比例，多个应用无法组成适当的比例的分屏，则进入中景
   */
  public needPairMidScene: boolean = false;

  private changeSplitRatioCallback?: Function;

  /**
   * 三折叠产品，应用定制固定分屏比例，强制改变比例，注册回调
   */
  public registerChangeSplitRatioCallback(callback: Function): void {
    log.showInfo(`[SCBSplit] registerChangeSplitRatioCallback`);
    this.changeSplitRatioCallback = callback;
  }

  /**
   * 三折叠产品，应用定制固定分屏比例，强制改变比例，解注册
   */
  public unregisterChangeSplitRatioCallback(): void {
    log.showInfo(`[SCBSplit] unregisterChangeSplitRatioCallback`);
    this.changeSplitRatioCallback = undefined;
  }

  /**
   * 三折叠产品，应用定制固定分屏比例，强制改变比例
   */
  public changeSplitRatio(): boolean {
    if (this.changeSplitRatioCallback) {
      log.showInfo(`[SCBSplit] changeSplitRatio`);
      this.changeSplitRatioCallback();
      return true;
    }
    return false;
  }

  /**
   * init param
   */
  public init(): void {
    this.needShowTitleBar = true;
    this.needShowIcon = false;
    this.oneStepExitNeedAnimation = true;
    this.isPreSplit = false;
    this.showInputMethodFlag = 1;
    this.needShowExitSplitToastForFolded = false;
    this.needDelayRotation = 0;
    this.hasAvoidInputMethod = false;
  }

  public setLifeCycle(lifeCycle: SplitLifeCycle): void {
    log.showInfo(`[Split] setLifeCycle ${lifeCycle}`);
    if (this.checkLifeCycleValid(lifeCycle) === false) {
      log.showError(`[Split] setLifeCycle ${this.lifeCycle} fail , curLifeCycle is ${this.lifeCycle}`);
      return;
    }
    this.lifeCycle = lifeCycle;
  }

  public getLifeCycle(): SplitLifeCycle {
    return this.lifeCycle;
  }

  private checkLifeCycleValid(lifeCycle: SplitLifeCycle): boolean {
    if (this.lifeCycle === SplitLifeCycle.EXIT_SPLIT_TO_ONESTEP && lifeCycle === SplitLifeCycle.SPLIT) {
      return false;
    }
    return true;
  }

  /**
   * set split-ratio into cache map
   *
   * @param cacheItem the item that need to be cached
   * @param splitRatio split-ratio value
   */
  public setSplitRatioCache(cacheItem: SplitRatioCacheKey, splitRatio: SplitRatioEnum): void {
    this.splitRatioCacheMap.set(cacheItem, splitRatio);
  }

  /**
   * fetch split-ratio from cache map
   *
   * @param cacheItem the item that need to be fetched
   * @returns split-ratio value
   */
  public getSplitRatioCache(cacheItem: SplitRatioCacheKey): SplitRatioEnum {
    if (this.splitRatioCacheMap.has(cacheItem)) {
      return this.splitRatioCacheMap.get(cacheItem);
    }
    return SplitRatioEnum.UNDEFINED;
  }


  /**
   * set split ratio cache only in G mode
   *
   * @param splitRatio split-ratio enum
   */
  public setThreeFoldSplitRatioCache(splitRatio: SplitRatioEnum): void {
    if (!DeviceHelper.isThreeFoldProduct()) {
      return;
    }
    if (DeviceHelper.isFoldExpanded()) {
      return;
    }
    if (this.getSplitRatioCache(SplitRatioCacheKey.PREV_DIVIDER_RATIO) === splitRatio) {
      log.showDebug(`[SCBSplit] same splitRatio:${splitRatio}`);
      return;
    }
    this.setSplitRatioCache(SplitRatioCacheKey.PREV_DIVIDER_RATIO, splitRatio);
    if (!SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      this.clearGModeSplitRatioCache();
      return;
    }
    log.showInfo(`[SCBSplit] set splitRatio cache:${splitRatio}`);
    this.setSplitRatioCache(SplitRatioCacheKey.G_MODE_DIVIDER_RATIO, splitRatio);
  }

  /**
   * set split ratio cache only for pad
   *
   * @param splitRatio split-ratio enum
   */
  public setSplitRatioCacheForPad(splitRatio: SplitRatioEnum): void {
    const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType !== SCBConstants.UITYPE_PAD) {
      return;
    }
    log.showInfo(`[SCBSplit] set splitRatio cache:${splitRatio}`);
    this.setSplitRatioCache(SplitRatioCacheKey.PAD_DIVIDER_RATIO, splitRatio);
  }

  /**
   * get cache split ratio, convert to numerical value
   *
   * @returns split ratio value
   */
  public getSplitRatioCacheForPad(): number {
    let splitRadio = 1 / 2;
    let splitRadioInCache = this.getSplitRatioCache(SplitRatioCacheKey.PAD_DIVIDER_RATIO);
    switch (splitRadioInCache) {
      case SplitRatioEnum.ONE_TO_TWO:
        splitRadio = 1 / 3;
        break;
      case SplitRatioEnum.TWO_TO_ONE:
        splitRadio = 2 / 3;
        break;
      default:
        splitRadio = 1 / 2;
    }
    log.showInfo(`[SCBSplit] get pad splitRatio:${splitRadio}`);
    return splitRadio;
  }

  /**
   * clear split ratio cache
   */
  public clearSplitRatioCacheForPad(): void {
    const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType !== SCBConstants.UITYPE_PAD) {
      return;
    }
    log.showInfo('[SCBSplit] clean pad splitRatio');
    this.setSplitRatioCache(SplitRatioCacheKey.PAD_DIVIDER_RATIO, SplitRatioEnum.UNDEFINED);
  }

  /**
   * get cache split ratio, convert to numerical value
   *
   * @returns split ratio value
   */
  public getGModeSplitRatioCache(): number {
    let splitRadio = 1 / 2;
    if (!SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      return splitRadio;
    }
    let splitRadioInCache = this.getSplitRatioCache(SplitRatioCacheKey.G_MODE_DIVIDER_RATIO);
    switch (splitRadioInCache) {
      case SplitRatioEnum.ONE_TO_TWO:
        splitRadio = 1 / 3;
        break;
      case SplitRatioEnum.TWO_TO_ONE:
        splitRadio = 2 / 3;
        break;
      default:
        splitRadio = 1 / 2;
    }
    this.setSplitRatioCache(SplitRatioCacheKey.PREV_DIVIDER_RATIO, splitRadioInCache);
    log.showInfo(`[SCBSplit] get G-mode splitRatio:${splitRadio}`);
    return splitRadio;
  }

  /**
   * get GMode Split Ratio Cache For MidScene
   * @returns split ratio cache arr
   */
  public getGModeSplitRatioCacheForMidScene(): number[] {
    let splitRatio = [1, 1];
    let splitRatioInCache = this.getSplitRatioCache(SplitRatioCacheKey.G_MODE_DIVIDER_RATIO);
    switch (splitRatioInCache) {
      case SplitRatioEnum.ONE_TO_TWO:
        splitRatio = [1, 2];
        break;
      case SplitRatioEnum.TWO_TO_ONE:
        splitRatio = [2, 1];
        break;
      default:
        splitRatio = [1, 1];
    }
    return splitRatio;
  }

  /**
   * clear split ratio cache
   */
  public clearGModeSplitRatioCache(): void {
    if (!DeviceHelper.isThreeFoldProduct()) {
      return;
    }
    log.showInfo(`[SCBSplit] clean G-mode splitRatio`);
    this.setSplitRatioCache(SplitRatioCacheKey.G_MODE_DIVIDER_RATIO, SplitRatioEnum.UNDEFINED);
  }

  /**
   * clear prev split ratio cache
   */
  public clearPrevSplitRatio(): void {
    if (!DeviceHelper.isThreeFoldProduct()) {
      return;
    }
    log.showInfo(`[SCBSplit] splitRatio reset prevSplitRatio`);
    this.setSplitRatioCache(SplitRatioCacheKey.PREV_DIVIDER_RATIO, SplitRatioEnum.UNDEFINED);
  }

  public increNeedDelayRotation(): void {
    log.showInfo(`increNeedDelayRotation curValue: ${this.needDelayRotation} newValue: ${this.needDelayRotation + 1}`);
    this.needDelayRotation++;
  }

  public decreNeedDelayRotation(): void {
    log.showInfo(`decreNeedDelayRotation curValue: ${this.needDelayRotation} newValue: ${this.needDelayRotation - 1}`);
    this.needDelayRotation--;
  }

  public getNeedDelayRotation(): number {
    return this.needDelayRotation;
  }

  public compareOnTouchRotation(screenProperty: SCBScreenProperty): boolean {
    // If user does long presses and rotate at the same time, panGesture should not be recognized
    let lastRotation = this.onTouchRotation;
    this.setOnTouchRotation(screenProperty);
    if (lastRotation !== this.onTouchRotation) {
      log.showInfo(`[SCBSplit]compareOnTouchRotation, lastRotation: ${lastRotation},currRotaion: ${this.onTouchRotation}`);
    }
    return lastRotation === this.onTouchRotation;
  }

  public setOnTouchRotation(screenProperty: SCBScreenProperty): void {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (screenSession) {
      screenProperty = screenSession.sensorScreenProperty;
    }
    this.onTouchRotation = screenProperty.rotation;
  }

  public set needDelayTitleAppear(value: boolean) {
    this._needDelayTitleAppear = value;
  }

  public get needDelayTitleAppear(): boolean {
    return this._needDelayTitleAppear;
  }
}