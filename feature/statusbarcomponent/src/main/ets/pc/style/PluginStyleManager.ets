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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginContentEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

import { StatusBarType } from '@ohos/systemuicommon';
import { StatusBarTint } from '../../common/StatusBarTint';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';
import { PluginNotifyBase } from '../pluginData/PluginNotifyBase';
import { GroupStyleCreator } from './creator/GroupStyleCreator';
import { LocalGroupStyleCreator } from './creator/LocalGroupStyleCreator';
import { PluginStyleCreator } from './creator/PluginStyleCreator';
import { StatusBarStyleCreator } from './creator/StatusBarStyleCreator';
import { StyleCreatorBase } from './creator/StyleCreatorBase';
import { PluginStyle } from './PluginStyle';
import { StyleType } from '../utils/enum';
import { PluginProperty } from '../viewdata/PluginProperty';
import { StatusBarEventManager } from '../manager/StatusBarEventManager';
import { PluginStyleChangeListener, StyleSwitchManager } from '../pluginstyleswitch/StyleSwitchManager';
import { PluginDisplayStyle, PluginPositionType } from '../common/PluginConstants';
import { StatusBarStyle } from './PcStatusBarStyle';
import { GroupStyle } from './PcStatusBarGroupStyle';
import { BaseStyle } from './BaseStyle';
import { PluginStyleUtil } from '../common/PluginStyleUtil';

const TAG = 'StyleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 状态栏根组件唯一标示
 */
const SB_ROOT_ID: Map<PluginDisplayStyle, string> = new Map([
  [PluginDisplayStyle.WINDOWS_STYLE, 'sb_root_window_status_bar'],
]);

const DOCK_STATUS_BAR_ROOT_ID = 'sb_root_dock_status_bar';

/**
 * 样式管理
 *
 * @since 2024-8-13
 */
export class StyleManager extends PluginNotifyBase implements PluginStyleChangeListener {
  private statusBarType: number = StatusBarType.TYPE_MAIN_MAC_STATUS_BAR;

  private styleCreatorMap: Map<StyleType, StyleCreatorBase> = new Map()
    .set(StyleType.PLUGIN, new PluginStyleCreator())
    .set(StyleType.LOCAL_GROUP, new LocalGroupStyleCreator())
    .set(StyleType.GROUP, new GroupStyleCreator())
    .set(StyleType.STATUS_BAR, new StatusBarStyleCreator());

  private styles: Map<string, BaseStyle | null> = new Map();
  private static mInstance: StyleManager;

  /**
   * 生产图标内容沉浸式事件
   *
   * @param slot 图标标示
   * @return 事件
   */
  private onProducePluginContentEvent = (slot?: string): PluginContentEvent => {
    if (slot) {
      let property = PluginListAdapter.getInstance().getPluginPropertyBySlot(slot);
      let color = this.getTintContentColor(property?.area);
      log.showDebug(`onProducePluginContentEvent slot:${slot}, color:${color}`);
      let pluginSlotMap: Map<string, string> = new Map();
      pluginSlotMap.set(slot, color);
      return PluginContentEvent.create(this.getStatusBarRootId(), pluginSlotMap);
    }
    return new PluginContentEvent();
  }

  protected addPlugin(pluginInfos: PluginProperty[]): void {
    return;
  }

  protected removePlugin(pluginInfos: PluginProperty[]): void {
    return;
  }

  protected updatePlugin(pluginInfos: PluginProperty[]): void {
    return;
  }

  protected initDiff(): void {
    log.showInfo('initDiff');
    StatusBarEventManager.getInstance()
      .produceOn(TAG, PluginContentEvent, this.onProducePluginContentEvent)// 所有状态栏注册图标内容沉浸式生产者
    StyleSwitchManager.getInstance().registerDataChangeListener(this);
  }

  /**
   * 根据图标位置获取对应内容颜色
   *
   * @param iconArea 图标区域
   */
  private getTintContentColor(iconArea?: Area): string {
    return StatusBarTint.CONTENT_COLOR_WHITE;
  }

  /**
   * 获取状态栏根组件id
   *
   * @return 唯一标示
   */
  public getStatusBarRootId(): string {
    let mainType = PluginStyleUtil.getCurStatusBarType();
    return SB_ROOT_ID.get(mainType) ?? '';
  }

  protected deInitDiff(): void {
    log.showInfo('deInitDiff');
    StatusBarEventManager.getInstance().offAll(TAG);
    StyleSwitchManager.getInstance().unregisterDataChangeListener(this);
  }

  public static getInstance(): StyleManager {
    if (!StyleManager.mInstance) {
      StyleManager.mInstance = new StyleManager();
    }
    return StyleManager.mInstance;
  }

  public getBackgroundColor(): ResourceColor | undefined {
    return undefined;
  }

  public requestStyle(styleType: StyleType, key: string): BaseStyle | null {
    let style = this.styles.get(key) ?? null;
    if (!style) {
      style = this.styleCreatorMap.get(styleType)?.create(key) ?? null;
      style?.init(PluginStyleUtil.getCurStatusBarTypeValue());
      this.styles.set(key, style);
    }
    return style;
  }

  public getStatusBarStyle(): StatusBarStyle {
    let style = this.requestStyle(StyleType.STATUS_BAR, this.getStatusBarRootId());
    return style as StatusBarStyle;
  }

  public getDockStatusBarStyle(): StatusBarStyle {
    let style = this.requestStyle(StyleType.STATUS_BAR, DOCK_STATUS_BAR_ROOT_ID);
    return style as StatusBarStyle;
  }

  clear(): void {
    for (const key of this.styles.keys()) {
      if (key !== this.getStatusBarRootId() && key !== DOCK_STATUS_BAR_ROOT_ID) {
        this.styles.delete(key);
      }
    }
    log.showInfo('clear, styles length:' + this.styles.size);
  }

  initStyle(): void {
    this.styles.forEach((style) => {
      style?.init(this.statusBarType);
    })
  }

  copy(key: string, style: BaseStyle): void {
    this.styles.get(key)?.copy(style);
  }

  notifyPluginStyleChange(newStyle: PluginDisplayStyle, oldStyle: PluginDisplayStyle): void {
    if (newStyle === PluginDisplayStyle.WINDOWS_STYLE) {
      this.getStatusBarStyle().opacity = 0;
      this.getDockStatusBarStyle().opacity = 1.0;
    }
  }

  onStatusBarChange(statusBarType: PluginDisplayStyle): void {
    this.statusBarType = statusBarType;
    this.styles.forEach((style) => {
      style?.onStatusBarChange(statusBarType);
    })
  }

  /**
   * 更新图标资源样式
   *
   * @param info 资源信息
   * @param index 索引
   */
  updatePluginMargin(slot: string, index: number, statusBarType: number, isFirst: boolean = false): void {
    let style: PluginStyle = this.styles.get(slot) as PluginStyle;
    if (!style) {
      log.showError(`updatePluginStyle invalid slot ${slot}}`);
      return;
    }
    let plugin: PluginProperty | null = PluginListAdapter.getInstance().getPluginPropertyBySlot(slot);
    if (plugin === null) {
      log.showError(`updatePluginStyle fail slot ${slot}}`);
      return;
    }

    let iconSpace: Length = 0;
    let group = this.styles.get(PluginPositionType[plugin.getPluginInPosition()]);
    if (group && group instanceof GroupStyle) {
      iconSpace = (group as GroupStyle).iconSpace;
    }
    style.updatePluginMargin(iconSpace, slot, index, statusBarType, isFirst);
  }
}