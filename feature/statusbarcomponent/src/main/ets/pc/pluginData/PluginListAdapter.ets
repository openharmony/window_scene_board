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
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginAccessInfo, PluginConstants,
  PluginInfo,
  PluginParseInfo } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { PluginParseMgr } from '@ohos/systemuicommon';

import { PluginProperty } from '../viewdata/PluginProperty';
import { StatusBarPluginEventListener } from './StatusBarPluginEventListener';

const TAG = 'PluginListAdapter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 图标数据适配器
 *
 * @since 2025-1-6
 */
export class PluginListAdapter {
  private static mInstance: PluginListAdapter;

  /**
   * 数据集
   */
  private myDataSource: Array<PluginProperty> = [];

  /**
   * 数据变化监听器集
   */
  private dataListeners: Array<StatusBarPluginEventListener> = [];

  public static getInstance(): PluginListAdapter {
    if (!PluginListAdapter.mInstance) {
      PluginListAdapter.mInstance = new PluginListAdapter();
    }
    return PluginListAdapter.mInstance;
  }

  /**
   * 注册数据变化监听
   *
   * @param listener 监听器
   */
  registerDataChangeListener(listener: StatusBarPluginEventListener): void {
    ArrayUtils.updateArr(this.dataListeners, listener);
    this.dataListeners.sort((a, b) => a.getPriority() - b.getPriority());
    if (this.myDataSource.length > 0) {
      log.showInfo('registerDataChangeListener, myDataSource length:' + this.myDataSource.length);
      listener.addPlugins(this.myDataSource);
    }
  }

  /**
   * 注销数据变化监听
   *
   * @param listener 监听器
   */
  unregisterDataChangeListener(listener: StatusBarPluginEventListener): void {
    ArrayUtils.deleteArr(this.dataListeners, listener);
  }

  /**
   * 获取单条目数据
   *
   * @param index 条目索引
   */
  getData(index: number): PluginProperty | null {
    if (index < 0 || index >= this.myDataSource.length) {
      log.error('invalid index:' + index + ',myDataSource length:' + this.myDataSource.length);
      return null;
    }
    return this.myDataSource[index];
  }

  getAllData(): Array<PluginProperty> {
    return this.myDataSource;
  }

  getPluginPropertyBySlot(slot: string): PluginProperty | null {
    const index = this.myDataSource.findIndex(item => item.getSlot() == slot);
    if (index < 0 || index >= this.myDataSource.length) {
      return null;
    }
    return this.myDataSource[index];
  }

  getPluginPropertyByTokenId(tokenId: number, instanceKey: string): PluginProperty | null {
    const index = this.myDataSource.findIndex(pluginInfo => {
      let info = pluginInfo?.pluginInfo;
      if (!(info instanceof PluginAccessInfo)) {
        return false;
      }
      return pluginInfo?.pluginInfo?.pluginParseInfo?.isAccessPlugin && (pluginInfo?.pluginInfo as PluginAccessInfo)
        .accessTokenId === tokenId && (pluginInfo?.pluginInfo as PluginAccessInfo).pluginParseInfo
        .instanceKey === instanceKey;
    });
    if (index < 0 || index >= this.myDataSource.length) {
      return null;
    }
    return this.myDataSource[index];
  }

  addData(data: PluginProperty[]): void {
    this.addOrUpdateData(data);
  }

  addEmptyData(slot: string): PluginProperty {
    let plugin: PluginParseInfo = PluginParseMgr.createLocalPlugin(PluginConstants.ACTION_PLUGIN_STATUS_BAR, slot);
    let pluginArray: PluginInfo[] = PluginParseMgr.castPluginInfo([plugin]);
    let pluginProperty: PluginProperty = new PluginProperty(pluginArray[0]);
    ArrayUtils.updateArr(this.myDataSource, pluginProperty);
		return pluginProperty;
	}

  removeEmptyData(plugins: Set<string>): void {
    plugins.forEach(slot => {
      let plugin: PluginProperty | null = PluginListAdapter.getInstance().getPluginPropertyBySlot(slot);
      if (plugin === null) {
        return;
      }
      ArrayUtils.deleteArr(this.myDataSource, plugin);
    });
  }

  removeData(data: PluginProperty[]): void {
    data.forEach((item) => ArrayUtils.deleteArr(this.myDataSource, item));
    this.notifyRemoveData(data);
  }

  updateData(data: PluginProperty[]): void {
    this.addOrUpdateData(data);
  }

  private addOrUpdateData(data: PluginProperty[]): void {
    let addPlugins: PluginProperty[] = [];
    let updatePlugins: PluginProperty[] = [];
    data.forEach((item) => {
      let oldPlugin = ArrayUtils.find(this.myDataSource, item);
      if (oldPlugin != null) {
        item.updatePluginProperty(oldPlugin);
        updatePlugins.push(item);
      } else {
        addPlugins.push(item);
      }
      ArrayUtils.updateArr(this.myDataSource, item);
    });
    this.notifyAddData(addPlugins);
    this.notifyUpdateData(updatePlugins);
  }

  private notifyAddData(data: PluginProperty[]) {
    this.dataListeners.forEach((listener: StatusBarPluginEventListener) => {
      listener?.addPlugins(data);
    });
  }

  private notifyRemoveData(data: PluginProperty[]) {
    this.dataListeners.forEach((listener: StatusBarPluginEventListener) => {
      listener?.removePlugins(data);
    });
  }

  private notifyUpdateData(data: PluginProperty[]) {
    this.dataListeners.forEach((listener: StatusBarPluginEventListener) => {
      listener?.updatePlugins(data);
    });
  }
}