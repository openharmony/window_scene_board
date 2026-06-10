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

import { ArrayUtils, CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { EventManager, EvtBus, StatusBarBackgroundEvent, ViewType } from '@ohos/frameworkwrapper';

import {
  DropdownViewControllerAdapter,
  SceneSessionAdapter, StatusBarType, WindowAdapter, } from '@ohos/systemuicommon';

import Window from '@ohos.window';

import { StatusBarTint } from '../common/StatusBarTint';

import statusBarBackgroundVM from './StatusBarBackgroundVM';
import {
  StatusBarMoveDownVmV1,
  StatusBarMoveDownVmV2
} from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarMoveDownVm';
import { SCBSystemBarProperty } from '@ohos/windowscene';
import {
  IStatusBarManager,
  HideStatusBarScene
} from '@ohos/systemuicommon/src/main/ets/statusbar/manager/StatusBarManager';
import { display } from '@kit.ArkUI';
import { sharedData } from '@ohos/systemuicommon/Index';

const TAG = 'StatusBarVMV2';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);


/**
 * 状态栏透明度动效时长
 */
const STATUS_BAR_OPACITY_DURATION = 300;
/**
 * 状态栏颜色设置时长
 */
const STATUS_BAR_COLOR_DURATION = 250;
/**
 * 状态栏数据处理
 *
 * @since 2022-10-18
 */
export class StatusBarVMV2 implements IStatusBarManager {
  /**
   * 状态栏沉浸式集
   */
  private statusBarTints: StatusBarTint[] = [];
  /**
   * 状态栏背景颜色变更事件
   */
  private sbBgEvent: StatusBarBackgroundEvent = StatusBarBackgroundEvent.create([], []);
  private eventMgr: EventManager = EvtBus.createEventManager();
  /*
   延迟发送插件颜色变化的定时器
   */
  private postPluginContentEventTimer?: number;
  /**
   * 状态栏隐藏事件回调
   */
  private statusbarHideEvent: Function | undefined = undefined;
  private callback: ComponentCallback | null = null;
  public isKeyguardHide: boolean = true;

  registerStatusbarHideEvent(statusbarEvent: Function | undefined): void {
    this.statusbarHideEvent = statusbarEvent;
  }

  init(statusBarType: number, callback: ComponentCallback): void {
    log.showInfo('init start status bar v2 vm');
    this.callback = callback;
    // 初始化状态栏类型与数据
    this.setStatusBarType(statusBarType);

    // 状态栏注册背景沉浸式生产者
    this.eventMgr.produceOn(StatusBarBackgroundEvent, this.onProduceSbBgEvent);
    log.showInfo('init start status bar vm end');

    SceneSessionAdapter.registerSystemBarPropertyCallbacks({
      callback: this.systemBarPropertyCallback,
      screenId: undefined
    }, `${TAG}_registerSystemBarPropertyCallbacks`);
    SceneSessionAdapter.updateSystemBarProperty();
    this.registerFoldDisplayMode();
  }

  unInit() {
    this.unRegisterFoldDisplayMode();
    SceneSessionAdapter.unRegisterSystemBarPropertyCallbacks({
      callback: this.systemBarPropertyCallback,
      screenId: undefined
    }, `${TAG}_unRegisterSystemBarPropertyCallbacks`);
    this.eventMgr.offAll();
  }

  private registerFoldDisplayMode(): void {
    try {
      this.setFoldDisplayMode(display.getFoldDisplayMode());
      display.on('foldDisplayModeChange', this.setFoldDisplayMode);
    } catch (error) {
      log.showError(`on foldDisplayModeChange error ${error?.message}`);
    }
  }

  private unRegisterFoldDisplayMode(): void {
    try {
      display.off('foldDisplayModeChange', this.setFoldDisplayMode);
    } catch (error) {
      log.showError(`destroy foldDisplayModeChange error ${error?.message}`);
    }
  }

  private setFoldDisplayMode = (foldDisplayMode: display.FoldDisplayMode) => {
    log.showInfo(`setFoldDisplayMode: ${foldDisplayMode}`)
    this.getMoveDownVM().setFoldDisplayMode(foldDisplayMode);
  }

  private systemBarPropertyCallback = (property: SCBSystemBarProperty) => {

    const oldContentColor: string = this.getTintContentColor();

    ArrayUtils.clearArr(this.statusBarTints);
    let sbTint = new StatusBarTint();
    sbTint.contentColor = property.contentcolor;
    sbTint.backgroundColor = property.backgroundcolor;
    sbTint.enableAnimation = property.enableAnimation;
    log.showWarn(`System bar property change from ${oldContentColor} to ${property?.contentcolor} ${property?.backgroundcolor}`);
    this.statusBarTints.push(sbTint);
    this.checkTintBgColorChange(property);
    log.showDebug('systemBarPropertyCallback');

    this.updateTintContentColor(property);
  }

  private updateTintContentColor(property?: SCBSystemBarProperty) {
    const contentColor: string = this.getTintContentColor();
    log.showInfo(`updateTintContentColor enable ${property?.enable}, ` +
      `enableAnimation ${property?.enableAnimation} contentColor ${contentColor}`);
    if (this.postPluginContentEventTimer) {
      log.showInfo(`post PluginContentEvent, so clear timer(${this.postPluginContentEventTimer}) for last event.`);
      clearTimeout(this.postPluginContentEventTimer);
      this.postPluginContentEventTimer = undefined;
    }
    // 状态栏隐藏，enableAnimation为true，状态栏图标内容颜色等opacity动效结束后再赋值
    if (!property?.enable && property?.enableAnimation) {
      this.postPluginContentEventTimer = setTimeout(() => {
        this.callback?.onPluginContentColorChange(contentColor);
        statusBarBackgroundVM.onContentColorChange(contentColor);
        clearTimeout(this.postPluginContentEventTimer);
        this.postPluginContentEventTimer = undefined;
      }, STATUS_BAR_COLOR_DURATION);
      log.showInfo(`start timer(${this.postPluginContentEventTimer}) to post PluginContentEvent after ${STATUS_BAR_COLOR_DURATION}ms.`);
    } else {
      this.callback?.onPluginContentColorChange(contentColor);
      statusBarBackgroundVM.onContentColorChange(contentColor);
    }
  }

  /**
   * 检测状态栏沉浸式背景颜色变更
   */
  private checkTintBgColorChange(property?: SCBSystemBarProperty): void {
    let bgColors: string[] = [];
    let regions: Window.Rect[] = [];
    let enableAnimations: boolean[] = [];
    // 默认背景色
    if (ArrayUtils.isEmpty(this.statusBarTints)) {
      bgColors.push(StatusBarTint.BG_COLOR_TRANSPARENT);
    } else {
      this.statusBarTints.forEach((tint) => {
        bgColors.push(tint.backgroundColor);
        regions.push(tint.region!);
        enableAnimations.push(tint.enableAnimation);
      });
    }
    let oldColors = this.sbBgEvent.bgColors;
    let oldRegions = this.sbBgEvent.regions;
    if (!this.isEqualsArr(oldColors, bgColors)) {
      this.sbBgEvent.bgColors = bgColors;
      this.sbBgEvent.regions = regions;
      this.sbBgEvent.enableAnimations = enableAnimations;
      // 状态栏隐藏， enableAnimation为true，状态栏背景色等opacity动效结束后再赋值
      if (!property?.enable && property?.enableAnimation) {
        setTimeout(() => {
          EvtBus.post(StatusBarBackgroundEvent, this.sbBgEvent);
        }, STATUS_BAR_OPACITY_DURATION);
      } else {
        EvtBus.post(StatusBarBackgroundEvent, this.sbBgEvent);
      }
      return;
    }
    if (!this.isRegionsEquals(oldRegions, regions)) {
      this.sbBgEvent.bgColors = bgColors;
      this.sbBgEvent.regions = regions;
      EvtBus.post(StatusBarBackgroundEvent, this.sbBgEvent);
      return;
    }
  }

  private isEqualsArr(oldArr: string[], newArr: string[]): boolean {
    if (oldArr.length !== newArr.length) {
      return false;
    }
    return oldArr.every((item) => newArr.includes(item));
  }

  /**
   * 判断region相等
   *
   * @param oriRegions regions1
   * @param otherRegions regions2
   */
  private isRegionsEquals(oriRegions: Window.Rect[], otherRegions: Window.Rect[]): boolean {
    if (ArrayUtils.isEmpty(oriRegions) || ArrayUtils.isEmpty(otherRegions)) {
      return ArrayUtils.isEmpty(oriRegions) && ArrayUtils.isEmpty(otherRegions);
    }
    if (oriRegions.length != otherRegions.length) {
      return false;
    }
    let result = oriRegions.find((region, index) => {
      return !CommonUtils.equalsRect(region, otherRegions[index]);
    });
    return CommonUtils.isInvalid(result);
  }

  /**
   * 根据图标位置获取对应内容颜色
   *
   * @param iconArea 图标区域
   */
  private getTintContentColor(iconArea?: Area): string {
    let defaultColor = StatusBarTint.CONTENT_COLOR_WHITE;
    // 无tint，默认颜色
    if (ArrayUtils.isEmpty(this.statusBarTints)) {
      return defaultColor;
    }
    let mapTint = this.statusBarTints.find((tint) => {
      return true;
    });
    if (CommonUtils.isInvalid(mapTint)) {
      return defaultColor;
    }
    return mapTint?.contentColor ?? defaultColor;
  }

  /**
   * 获取状态栏类型
   *
   * @return 状态栏类型
   */
  public getStatusBarType(): number {
    return this.callback?.getStatusBarType() ?? StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
  }

  /**
   * 下拉面板状态栏类型
   *
   * @return true 下拉面板状态栏
   */
  public isDropdown(): boolean {
    return StatusBarType.isDropdown(this.getStatusBarType());
  }

  /**
   * 获取状态栏透明度动效时长
   * @return 状态栏透明度动效时长
   */
  getStatusBarOpacityDuration(): number {
    return STATUS_BAR_OPACITY_DURATION;
  }

  public getMoveDownVM(): StatusBarMoveDownVmV2 | StatusBarMoveDownVmV1 {
    return StatusBarMoveDownVmV2.getInstance();
  }

  /**
   * 设置状态栏类型
   */
  public setStatusBarType(statusBarType?: number, isDropDown: boolean = false): void {
    let newStatusBarType = statusBarType ?? StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
    if (statusBarType === undefined) {
      newStatusBarType =
        !this.isKeyguardHide ? StatusBarType.TYPE_MAIN_PHONE_KEYGUARD : StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
    }
    if (!sharedData.isDropDownShow &&
      newStatusBarType === StatusBarType.TYPE_MAIN_PHONE_DROPDOWN) {
      return;
    }
    log.showWarn(`onSetStatusBarType ${newStatusBarType} ${isDropDown}`);
    if (this.statusbarHideEvent) {
      let lastStatusbarType = this.getStatusBarType();
      if (lastStatusbarType !== newStatusBarType && lastStatusbarType === StatusBarType.TYPE_MAIN_PHONE_DROPDOWN) {
        this.statusbarHideEvent(HideStatusBarScene.FROM_DROPDOWN, newStatusBarType);
      }
    }
    // 在宏任务更新setStatusBarType，避免arkUI动效执行过程中改变变量，导致异常动效
    setTimeout(() => {
      this.callback?.setStatusBarType(newStatusBarType, isDropDown);
    }, 0);

    this.getMoveDownVM().changeStatusBarType(newStatusBarType);
  }

  /**
   * 生产状态栏背景沉浸式事件
   *
   * @return 事件
   */
  private onProduceSbBgEvent = (): StatusBarBackgroundEvent => {
    return this.sbBgEvent;
  }
}

/**
 * 组件V2接收回调事件
 */
export interface ComponentCallback {
  /**
   * 状态栏图标颜色变化回调
   *
   * @param infos 状态栏内容颜色
   */
  onPluginContentColorChange(contentColor: string): void;

  /**
   * 状态栏类型变更
   */
  setStatusBarType(statusBarType: number, isDropDown: boolean): void;

  /**
   * 获取状态栏类型
   *
   * @return 状态栏类型
   */
  getStatusBarType(): number;
}

export const statusBarVMV2: StatusBarVMV2 = SingletonHelper.getInstance(StatusBarVMV2, TAG);