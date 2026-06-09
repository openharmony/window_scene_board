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
import { BaseAdapter } from '../../common/adapter/BaseAdapter';
import { ClockHookType, ConfigType, UseScene } from '../../common/adapter/Constans';
import { IHook } from '../../common/adapter/IHook';
import { ClockWidgetModel } from '../viewmodel/ClockWidgetModel';
import { ClockWidgetConfigManager, clockWidgetConfigManager } from '../common/ClockWidgetConfigManager';
import { ScreenLockClockStateManager } from '../../common/adapter/ScreenLockClockStateManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ClockDataManager } from '../commonbase/ClockDataManager';

const TAG = 'ClockAdapter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 适配器类，用于适配外部接入组件
 */
export class ClockAdapter extends BaseAdapter {
  /**
   * 未注入处理组件时使用默认内置插件
   */
  private defaultHooksMap: Map<ClockHookType, IHook> = new Map();

  /**
   * 时钟、艺术签名统一配置管理，向各个业务使用方的配置隔离演进
   */
  private configManager: ClockWidgetConfigManager;



  /**
   * 时钟业务管理
   */
  private clockWidgetModel = new ClockWidgetModel();

  /**
   * 时钟编辑状态管理
   */
  private clockEditStateMgr: ScreenLockClockStateManager = new ScreenLockClockStateManager();

  constructor(scene: UseScene) {
    super(scene);
    this.configManager = clockWidgetConfigManager;
    this.defaultHooksMap.set(ClockHookType.CLOCK_WIDGET_MODEL, this.clockWidgetModel);
    this.defaultHooksMap.set(ClockHookType.CLOCK_ANIM_MANAGER, this.clockWidgetModel.getClockAnimMgr());
    this.defaultHooksMap.set(ClockHookType.CLOCK_ONE_SHOT_ANIM_MANAGER, this.clockWidgetModel.getOneShotClockAnimMgr());
  }

  /**
   * 设置当前是否使用镜像布局
   *
   * @param isUsing true标识镜像
   */
  setMirrorLayoutUsing(isUsing: boolean): void {
    log.showInfo(`setMirrorLayoutUsing , new:${isUsing}`);
    this.clockWidgetModel.updateMirrorStatus(isUsing);
  }

  setClockShadowUsing(isUsing: boolean): void {
    log.showInfo(`setClockShadowUsing: switch to ${isUsing}`);
    this.getDataManager().getSlClockBindState().setShadowSwitch(isUsing);
  }

  getHook(type: ClockHookType): IHook | undefined {
    let injectComponent = super.getHook(type);
    if (!injectComponent) {
      injectComponent = this.defaultHooksMap.get(type);
    }
    return injectComponent;
  }

  getDataManager(): ClockDataManager {
    return this.clockWidgetModel.getDataManager();
  }

  getClockWidgetModel(): ClockWidgetModel {
    return this.clockWidgetModel;
  }


  getClockEditStateManger(): ScreenLockClockStateManager {
    return this.clockEditStateMgr;
  }

  protected doInit(params?: number | object | undefined): void {
    let listener = this.getClockWidgetModel()?.getEventListener();
    this.getInvoker().registerObserver(listener);
  }

  protected doRelease(): void {
    let listener = this.getClockWidgetModel()?.getEventListener();
    this.getInvoker().unRegisterObserver(listener);
  }


}

/**
 * 时钟组件适配器工厂类
 *
 */
export class ClockAdapterFactory {
  private static adapterMap: Map<UseScene, ClockAdapter> = new Map();

  /**
   * 获取适配器实例
   *
   * @param 组件使用场景
   * @returns 适配器
   */
  static wrapper(scene?: UseScene): ClockAdapter {
    let realScene = scene ?? UseScene.DEFAULT_SCENE;
    let adapter = ClockAdapterFactory.adapterMap.get(realScene);
    if (!adapter) {
      adapter = new ClockAdapter(realScene);
      ClockAdapterFactory.adapterMap.set(realScene, adapter);
    }
    return adapter;
  };
}