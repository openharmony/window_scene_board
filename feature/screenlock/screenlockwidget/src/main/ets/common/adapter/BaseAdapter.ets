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
import { AbstractInitialAble, InitialAble, ISlStateChangeListener } from '@ohos/screenlockcommon';
import { Invoker } from '../command/Invoker';
import { HookType, UseScene } from './Constans';
import { BaseConfig, IFeatureConfig } from './FeatureConfig';
import { IHook } from './IHook';
import { DataManager } from './DataManager';
import { SlMainStateType } from '@ohos/screenlockcommon';
import { ISlState } from '@ohos/screenlockcommon';

/**
 * 组件适配接口
 */
export interface IAdapter extends InitialAble {
  /**
   * 查询当前适配器使用场景
   *
   * @returns
   */
  getUseScene(): UseScene;

  /**
   * 获取命令调用者
   *
   * @returns 通信通道
   */
  getInvoker(): Invoker;

  /**
   * 组件使用方注册特性配置
   *
   * @param config
   */
  setConfig(config?: IFeatureConfig): void;

  /**
   * 查询特性配置
   *
   * @returns 配置
   */
  getConfig(): IFeatureConfig | undefined;

  /**
   * 组件外部向组件内部注入业务插件
   *
   * @param hook 业务插件
   */
  setHook(hook: IHook): void

  /**
   * 删除插件
   *
   * @param type 插件标识
   */
  deleteHook(type: HookType): void

  /**
   * 查询插件实例
   *
   * @param type 插件标识
   */
  getHook(type: HookType): IHook | undefined;

  /**
   * 注册数据观察者，监听数据变化
   *
   * @param dataType 数据类型
   * @param observer 观察者
   */
  registerObserver(dataType: SlMainStateType, observer: ISlStateChangeListener): void;

  /**
   * 注销数据观察者
   *
   * @param dataType 数据类型
   * @param observer 观察者
   */
  unRegisterObserver(dataType: SlMainStateType, observer: ISlStateChangeListener): void;
}

/**
 * 组件适配器基础类
 */
export abstract class BaseAdapter extends AbstractInitialAble implements IAdapter {
  /**
   * 适配器使用场景
   */
  private scene: UseScene = UseScene.DEFAULT_SCENE;

  /**
   * 命令调用者
   */
  private invoker: Invoker = new Invoker();

  /**
   * 保存业务插件，用来实现组件内业务扩展
   */
  private hooksMap: Map<HookType, IHook> = new Map();

  /**
   * 组件配置项
   */
  private config?: IFeatureConfig = new BaseConfig();

  constructor(scene: UseScene) {
    super();
    this.scene = scene;
  }

  /**
   * 获取数据管理器
   */
  abstract getDataManager(): DataManager;

  /**
   * 查询当前适配器使用场景
   *
   * @returns
   */
  getUseScene(): UseScene {
    return this.scene;
  }

  /**
   * 获取组件外向组件内通信通道
   *
   * @returns 通信通道
   */
  getInvoker(): Invoker {
    return this.invoker;
  }

  /**
   * 组件使用方注册特性配置
   *
   * @param config
   */
  setConfig(config?: IFeatureConfig): void {
    this.config = config;
  }

  /**
   * 查询特性配置
   *
   * @returns 配置
   */
  getConfig(): IFeatureConfig | undefined {
    return this.config;
  }

  /**
   * 组件外部向组件内部注入业务插件
   *
   * @param hook 业务插件
   */
  setHook(component: IHook): void {
    if (!component) {
      return;
    }
    this.hooksMap.set(component.getHookType(), component);
  }

  /**
   * 删除插件
   *
   * @param type 插件标识
   */
  deleteHook(type: HookType): void {
    this.hooksMap.delete(type);
  }

  /**
   * 查询插件实例
   *
   * @param type 插件标识
   */
  getHook(type: HookType): IHook | undefined {
    return this.hooksMap.get(type);
  }

  /**
   * 注册数据观察者，监听数据变化
   *
   * @param dataType 数据类型
   * @param observer 观察者
   */
  registerObserver(dataType: SlMainStateType, observer: ISlStateChangeListener): void {
    this.getDataManager().registerSlStateChangeListener(observer, dataType);
  }

  /**
   * 注销数据观察者
   *
   * @param dataType 数据类型
   * @param observer 观察者
   */
  unRegisterObserver(dataType: SlMainStateType, observer: ISlStateChangeListener): void {
    this.getDataManager().unregisterSlStateChangeListener(observer, dataType);
  }

  /**
   * 适配器初始化，打开内外通信通道等
   *
   * @param params 初始化参数
   */
  protected doInit(params?: number | object | undefined): void {
    this.getInvoker()?.init();
  }

  /**
   * 适配器销毁，关闭内外通信通道等
   *
   * @param params 初始化参数
   */
  protected doRelease(): void {
    this.getInvoker()?.release();
  }
}