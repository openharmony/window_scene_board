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

import type common from '@ohos.app.ability.common';
import parameter from '@ohos.systemparameter';
import util from '@ohos.util';
import type { EventManager } from '@ohos/frameworkwrapper';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DropDownPanelManagerWrapper,
  EvtBus,
  PluginRequestEvent,
  viewMgrPolicy,
  ViewType,
  sEventManager,
  obtainLocalEvent
} from '@ohos/frameworkwrapper';
import { FocusChangeReason } from '@ohos/windowscene';
import { DefaultPanelZIndex, SatelliteModeSwitchEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { BusinessError } from '@kit.BasicServicesKit';
import { ScreenLockApi, ScreenLockStateManager, ScreenLockUnlockService } from '@ohos/screenlockcommon';
import { SceneSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/SceneSessionAdapter';
import { ViewManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ViewManagerAdapter';
import { ScreenLockAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenLockAdapter';
import { ScreenLockApiAdapter } from '../adapter/ScreenLockApiAdapter';

const TAG = 'Model.BaseController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const UNLOCK_DELAY_TIME: number = 300;
const HANDLE_DELAY_TIME: number = 100;
const REDUCE_CONTROL_CENTER_HIERARCHY: number = 1990;

// copy from ./unlock/ScreenLockMediator.ets::ScreenLockStatus
enum ScreenLockStatus {
  LOCKING = 1,
  UNLOCK = 2
}

/**
 * Controller基类
 */
export abstract class BaseController<T extends CommonData> {
  protected records: Record<string, object> = {};

  public isNewStyleOpen: boolean = parameter.getSync('controlCenter.isNewStyle', 'true') === 'true';
  protected isAlreadyLoadLottie: boolean = false;

  /**
   * 状态栏图标可见性事件
   */
  protected sbPluginRequest: PluginRequestEvent = PluginRequestEvent.create(this.getSbPluginSlot(),
    PluginRequestEvent.REQUEST_TYPE_VISIBILITY, PluginRequestEvent.VALUE_VISIBILITY_GONE);

  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  private handle: Function = () => {
  };

  /**
   * plugin请求事件生产者
   *
   * @param slot plugin唯一标示
   * @return 事件
   */
  protected onProducePluginRequestEvent(slot?: string): PluginRequestEvent | null {
    if (slot !== this.getSbPluginSlot()) {
      return null;
    }
    return this.sbPluginRequest;
  }

  protected initLottieData(): void {
    log.showDebug('initLottieData');
    let openName: string = this.isNewStyleOpen ? this.getNewLottieOpenName() : this.getLottieOpenName();
    let closeName: string = this.isNewStyleOpen ? this.getNewLottieCloseName() : this.getLottieCloseName();
    if (!CommonUtils.isEmpty(openName)) {
      this.loadLottieData(openName, (value) => {
        this.records.lottieDataOpen = value;
      });
    }
    if (!CommonUtils.isEmpty(closeName)) {
      this.loadLottieData(closeName, (value) => {
        this.records.lottieDataClose = value;
      });
    }
    if (!CommonUtils.isEmpty(this.getLottieOpenDarkName())) {
      this.loadLottieData(this.getLottieOpenDarkName(), (value) => {
        this.records.lottieDataOpenDark = value;
      });
    }
    if (!CommonUtils.isEmpty(this.getLottieCloseDarkName())) {
      this.loadLottieData(this.getLottieCloseDarkName(), (value) => {
        this.records.lottieDataCloseDark = value;
      });
    }
  }

  /**
   * 移除lottie缓存
   */
  removeAllLottieData(): void {
    log.showInfo('removeAllLottieData');
    this.records = {};
    this.isAlreadyLoadLottie = false;
  }

  /**
   * 初始化lottie缓存
   */
  initAllLottieData(): void {
    log.showInfo(`initAllLottieData isAlreadyLoadLottie=${this.isAlreadyLoadLottie},isLoadLottie=${this.isLoadLottie()}`);
    if (this.isLoadLottie() && !this.isAlreadyLoadLottie) {
      this.isAlreadyLoadLottie = true;
      this.initLottieData();
    }
  }

  /**
   * 是否使用深色模式关闭lottie
   */
  isDarkReverse(): boolean {
    return false;
  }

  /**
   * 获取开启lottie对象
   */
  getOpenLottieData(): object {
    return this.records.lottieDataOpen;
  }

  /**
   * 获取关闭lottie
   */
  getCloseLottieData(): object {
    return this.records.lottieDataClose;
  }

  /**
   * 根据状态获取动画
   *
   * @param isDarkMode 是否深色模式开启
   */
  matchLottieData(isDarkMode: boolean): object {
    if (isDarkMode) {
      if (this.getData().status) {
        return this.records.lottieDataOpenDark;
      } else {
        return this.records.lottieDataCloseDark;
      }
    } else {
      if (this.getData().status) {
        return this.records.lottieDataOpen;
      } else {
        return this.records.lottieDataClose;
      }
    }
  }

  /**
   * 获取开启动画lottie名称
   */
  getLottieOpenName(): string {
    return '';
  }

  /**
   * 获取开启动画新lottie名称
   */
  getNewLottieOpenName(): string {
    return '';
  }

  /**
   * 获取开启关闭lottie名称
   */
  getLottieCloseName(): string {
    return '';
  }

  /**
   * 获取开启新关闭lottie名称
   */
  getNewLottieCloseName(): string {
    return '';
  }

  /**
   * 获取深色模式开启动画lottie名称
   */
  getLottieDarkName(): string {
    return '';
  }

  getLottieOpenDarkName(): string {
    return '';
  }

  getLottieCloseDarkName(): string {
    return '';
  }

  /**
   * 是否需要加载lottie
   */
  isLoadLottie(): boolean {
    return false;
  }

  /* 加载对应的动画 */
  public loadLottieData(jsonName: string, callback: (value: object) => void): void {
    log.showDebug('loadLottieData, jsonName = ' + jsonName);
    let resStr = new util.TextDecoder('utf-8', {
      ignoreBOM: true
    });
    try {
      let context = GlobalContext.getContext();
      context.resourceManager.getRawFile(jsonName, (err: Error, data: Uint8Array) => {
        if (data === null || data === undefined || data.buffer === undefined) {
          log.showError(`loadLottieData getRawFile error:${err?.message}`);
          return;
        }
        let lottieStr = resStr.decode(new Uint8Array(data.buffer));
        let lottieData: object = JSON.parse(lottieStr);
        log.showInfo(`loadLottieData, lottieData: ${jsonName}`);
        if (callback) {
          callback(lottieData);
        }
      });
    } catch (err) {
      log.showError('context is undefined');
    }
  }

  /* 异步加载对应的动画 */
  public async loadLottieDataAsync(jsonName: string, callback: (value: object) => void): Promise<void> {
    log.showDebug('loadLottieDataAsync, jsonName = ' + jsonName);
    let resStr = new util.TextDecoder('utf-8', {
      ignoreBOM: true
    });
    let context = GlobalContext.getContext();
    try {
      let data = await context.resourceManager.getRawFile(jsonName).catch((err: BusinessError) => {
        log.showError(`loadLottieDataAsync getRawFile failed, err: ${err.message}`);
      });
      if (data) {
        let lottieStr = resStr.decode(new Uint8Array(data.buffer));
        let lottieData: object = JSON.parse(lottieStr);
        if (callback) {
          callback(lottieData);
        }
        log.showInfo(`loadLottieDataAsync, lottieData: ${jsonName}`);
      }
    } catch (err) {
      log.showError(`loadLottieDataAsync failed, err: ${err.message}`);
    }
  }

  /**
   * 是否需要监听卫星通信状态
   */
  needListenSatelliteMode(): boolean {
    return false;
  }

  protected onSatelliteModeSwitchEvent = (event: SatelliteModeSwitchEvent): void => {
    if (event === undefined) {
      return;
    }
    this.getData().isSatelliteMode = event.satelliteModeSwitch();
    log.showInfo('onSatelliteModeSwitchEvent switch: ' + this.getData().isSatelliteMode);
    this.updateDisableState();
  };

  /**
   * 更新快捷开关的置灰状态
   */
  updateDisableState(): void {
  }

  /**
   * 初始化Controller
   */
  onStart(): void {
    // 存在slot，注册可见性事件生产者
    if (!CommonUtils.isEmpty(this.getSbPluginSlot())) {
      this.eventMgr.produceOn(PluginRequestEvent,
        (slot?: string): PluginRequestEvent | null => this.onProducePluginRequestEvent(slot));
    }
    if (this.needListenSatelliteMode()) {
      this.eventMgr.on(SatelliteModeSwitchEvent, this.onSatelliteModeSwitchEvent);
    }
  }

  /**
   * 销毁Controller
   */
  onStop(): void {
    this.eventMgr.offAll();
  }

  /**
   * 处理状态刷新
   */
  handleUpdateState(): void {
  };

  /**
   * 获取绑定数据
   */
  abstract getData(): T;

  /**
   * 是否可用
   */
  abstract isAvailable(): boolean;

  /**
   * 状态栏plugin图标唯一标示
   *
   * @return 默认无
   */
  getSbPluginSlot(): string {
    return '';
  }

  /**
   * 添加状态监听
   */
  addStateChangedListener(): void {
  };

  /**
   * 移除状态监听
   */
  removeStateChangedListener(): void {
  };

  /**
   * 处理开关点击事件
   */
  handleClick(): boolean {
    return false;
  }

  /**
   * 处理开关长按事件
   */
  handleLongClick(): boolean {
    return false;
  }

  /**
   * 名称点击事件
   *
   * @param slot 名称
   */
  handleLabelClick(slot: string): boolean {
    return false;
  }

  /**
   * hover事件
   *
   * @param isHover 是否显示hover效果
   */
  handleHover(isHover: boolean): void {
  }

  protected handleClickIfUnlock(): void {
    log.showInfo('handleClickIfUnlock');
    let status: ScreenLockStatus | undefined = AppStorage.get('lockStatus');
    if (status === ScreenLockStatus.UNLOCK) {
      this.handle();
    }
  }

  /**
   * 处理点击事件-在锁屏和锁屏编辑页面场景下均解锁后操作
   *
   * @param handle handle
   */
  handleClickWithScreenLockAndEdit(handle: Function): void {
    if (ScreenLockApiAdapter.isUseNewScreenLock()) {
      if (!ScreenLockApiAdapter.isScreenLockShow()) {
        log.showInfo('page not show, do handle direct.');
        handle?.();
      } else {
        log.showInfo('page show, request lock.');
        AppStorage.setOrCreate('isAnimToHide', true);
        ScreenLockAdapter.requestUnlockScreenLockUnlockService({success: handle}, `${TAG}_requestUnlockScreenLockUnlockService`);
      }
      return;
    }
    this.handle = handle;
    if (ScreenLockAdapter.getLock() || AppStorage.get('isHomeVisible') === true) {
      let status: ScreenLockStatus | undefined = AppStorage.get('lockStatus');
      if (status !== ScreenLockStatus.UNLOCK) {
        ScreenLockAdapter.requestUnlock({
          success: this.handleClickIfUnlock,
          withDelay: true
        }, `${TAG}_requestUnlock`);
        AppStorage.setOrCreate('isAnimToHide', true);
        return;
      }
      ScreenLockAdapter.unlockWhenNoPsw();
    }
    handle();
  }

  protected handleGoSettingIfUnlock(): void {
    let status: ScreenLockStatus | undefined = AppStorage.get('lockStatus');
    if (status === ScreenLockStatus.UNLOCK) {
      // 解锁后拉起桌面应用
      ScreenLockAdapter.notifyUnlockTransitionForPc();
      this.goSettingWithDelay(UNLOCK_DELAY_TIME);
    }
  }

  handleGoSettingWithScreenLock(handle: Function): void {
    if (ScreenLockApiAdapter.isUseNewScreenLock()) {
      if (!ScreenLockApiAdapter.isScreenLockShow()) {
        log.showInfo('page not show, do handle direct.');
        handle?.();
      } else {
        log.showInfo('page show, request lock.');
        AppStorage.setOrCreate('isAnimToHide', true);
        ScreenLockAdapter.requestUnlockScreenLockUnlockService({
          success: () => {
            this.handle = handle;
            this.goSettingWithDelay(UNLOCK_DELAY_TIME);
          }
        }, `${TAG}_requestUnlockScreenLockUnlockService`);
      }
      return;
    }
    this.handle = handle;
    if (ScreenLockAdapter.getLock()) {
      let status: ScreenLockStatus | undefined = AppStorage.get('lockStatus');
      if (status !== ScreenLockStatus.UNLOCK) {
        ScreenLockAdapter.requestUnlock({
          success: this.handleGoSettingIfUnlock,
          withDelay: true
        }, `${TAG}_requestUnlock`);
        AppStorage.setOrCreate('isAnimToHide', true);
        return;
      }
      ScreenLockAdapter.unlockWhenNoPsw();
      AppStorage.setOrCreate('isAnimToHide', true);
      this.goSettingWithDelay(UNLOCK_DELAY_TIME);
      return;
    }
    handle();
  }

  /**
   * 延时启动锁屏界面跳转设置界面
   */
  goSettingWithDelay(delay: number): void {
    setTimeout(() => {
      this.handle();
    }, delay);
  }

  /**
   * 延时调用handle
   */
  handleDelay(delay: number, handle: Function): void {
    setTimeout(() => {
      handle();
    }, delay);
  }

  async requestUnlock(handle: Function, beforeUnlock: boolean): Promise<void> {
    // 请求解锁
    if (ScreenLockApiAdapter.isUseNewScreenLock()) {
      let notSuccess: Function = () => {
        // 解锁失败，收起控制中心
        DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
        // 恢复层级
        ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
      };
      ScreenLockAdapter.requestUnlockScreenLockUnlockService({
        authResultSuccess: async () => {
          if (!beforeUnlock) {
            handle();
          }
          // 解锁成功，恢复层级
          ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
          SceneSessionAdapter.requestFocus(await ViewManagerAdapter.getDropDownId(),
            undefined, FocusChangeReason.MOVE_UP);
        },
        cancel: notSuccess,
        fail: notSuccess
      }, `${TAG}_requestUnlockScreenLockUnlockService`);
    } else {
      ScreenLockAdapter.requestUnlock({
        authResultSuccess: async () => {
          if (!beforeUnlock) {
            handle();
          }
          // 解锁成功，恢复层级
          ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
          SceneSessionAdapter.requestFocus(await ViewManagerAdapter.getDropDownId(), undefined,
            FocusChangeReason.MOVE_UP);
        },
        withDelay: true,
        cancelCallback: () => {
          // 解锁失败，收起控制中心
          DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
          // 恢复层级
          ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
        }
      }, `${TAG}_requestUnlock`);
    }
    let persistentId = await ViewManagerAdapter.getDropDownId();
    log.showInfo(`requestUnlock persistentId: ${persistentId} release focus`);
    SceneSessionAdapter.requestUnfocus(persistentId, FocusChangeReason.BACKGROUND);
    // 降低控制中心层级
    ViewManagerAdapter.setDropDownZIndex(REDUCE_CONTROL_CENTER_HIERARCHY);
    // 跳转；播控中心无法动态改变层级，解锁后再跳转
    if (beforeUnlock) {
      handle();
    }
  }

  handleOnControlCenterWithScreenLock(handle: Function, beforeUnlock: boolean = true): void {
    if (ScreenLockApiAdapter.isUseNewScreenLock()) {
      if (!ScreenLockApiAdapter.isScreenLockShow()) {
        log.showInfo('page not show, do handle direct.');
        handle?.();
      } else {
        log.showInfo('page show, request lock.');
        if (!ScreenLockApiAdapter.isDeviceLocked()) {
          // 无密码：先跳转，后解锁
          handle?.();
          ScreenLockAdapter.requestUnlockScreenLockUnlockService({}, `${TAG}_requestUnlockScreenLockUnlockService`);
        } else {
          this.requestUnlock(handle, beforeUnlock);
        }
      }
      return;
    }
    if (ScreenLockAdapter.getLock()) {
      let status: ScreenLockStatus | undefined = AppStorage.get('lockStatus');
      if (status !== ScreenLockStatus.UNLOCK) {
        this.requestUnlock(handle, beforeUnlock);
        return;
      }
      // 无密码：先跳转，后解锁
      handle();
      ScreenLockAdapter.unlockWhenNoPsw();
      return;
    }
    handle();
  }

  /**
   * 由于UIExtension安全策略发生变化，锁屏下控制中心下拉适配，需要直接显示二级界面
   *
   * @param handle 回调函数
   */
  handleOnControlCenterWithScreenLockForUIE(handle: Function, hasSubPage: boolean = false,
    beforeUnlock: boolean = true): void {
    log.showInfo(`handleOnControlCenterWithScreenLockForUIE: hasSubPage=${hasSubPage} beforeUnlock=${beforeUnlock}`);
    if (ScreenLockApiAdapter.isScreenLockShow()) {
      let status: ScreenLockStatus | undefined = AppStorage.get('lockStatus');
      if (status !== ScreenLockStatus.UNLOCK) {
        if (hasSubPage) {
          // 锁屏有密码场景延迟拉起二级页
          this.handleDelay(HANDLE_DELAY_TIME, handle);
        }
        this.requestUnlockForUIE(handle, hasSubPage);
        return;
      }
      if (beforeUnlock) {
        // 无密码：先处理，后解锁
        handle();
        ScreenLockAdapter.unlockWhenNoPsw();
        if (hasSubPage) {
          sEventManager.publish(obtainLocalEvent('ControlCenterLockStatus', ScreenLockStatus.UNLOCK));
        }
      } else {
        // 无密码：先解锁，后处理
        ScreenLockAdapter.unlockWhenNoPsw();
        handle();
      }
      return;
    }
    handle();
  }

  async requestUnlockForUIE(handle: Function, hasSubPage: boolean): Promise<void> {
    let unlockSuccessCallback = async (): Promise<void> => {
      if (!hasSubPage) {
        handle();
      } else {
        sEventManager.publish(obtainLocalEvent('ControlCenterLockStatus', ScreenLockStatus.UNLOCK));
      }
      // 解锁成功，恢复层级
      ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
      SceneSessionAdapter.requestFocus(await ViewManagerAdapter.getDropDownId(),
        undefined, FocusChangeReason.MOVE_UP);
    };
    let unlockCancelCallback = (): void => {
      // 解锁失败，收起控制中心
      DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
      // 恢复层级
      ViewManagerAdapter.setDropDownZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
    };
    // 请求解锁
    ScreenLockAdapter.requestUnlock({
      success: unlockSuccessCallback,
      authResultSuccess: () => {
        sEventManager.publish(obtainLocalEvent('ControlCenterLockStatus', ScreenLockStatus.UNLOCK))
      },
      cancel: unlockCancelCallback,
      withDelay: true
    }, `${TAG}_requestUnlock`);
    let persistentId = await ViewManagerAdapter.getDropDownId();
    log.showInfo(`requestUnlock persistentId: ${persistentId} release focus`);
    SceneSessionAdapter.requestUnfocus(persistentId, FocusChangeReason.BACKGROUND);
    // 降低控制中心层级
    ViewManagerAdapter.setDropDownZIndex(REDUCE_CONTROL_CENTER_HIERARCHY);
  }
}

/**
 * 绑定数据基类
 */
export class CommonData {
  public status: boolean = false;
  public isUnavailable: boolean = false;
  public isSatelliteMode: boolean = false;
  public isAirplaneMode: boolean = false;
}

/**
 * Plugin绑定数据基类
 */
export class PluginToggleData extends CommonData {
}