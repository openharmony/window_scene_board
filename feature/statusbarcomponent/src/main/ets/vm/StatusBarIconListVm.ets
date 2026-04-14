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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  PluginConstants,
  PluginInfo,
  PluginRequestEvent,
  PluginSlot,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { IStatusBarIconListVm,
  IStatusBarIconVm,
  PluginPosition,
  StatusBarBaseVm,
  DEFAULT_ICON_WIDTH_MAP,
  CutoutVm,
  DeviceInfoVm,
  ResourceVm,
  EnvVm,
  LiveVmInjectorFactory,
} from '@ohos/systemuicommon/newIndex';
import {
  LayoutUtils,
  PluginParseMgr, StatusBarType, StatusBarTypeChangeEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { StatusBarMoveDownVmV2 } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarMoveDownVm';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { display } from '@kit.ArkUI';
import { XTLayoutType } from '@ohos/systemuicommon';
import { STATUS_BAR_LAYOUT_DEFAULT_ANCHOR } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusbarConstants';
import { StatusBarIconConfig } from '@ohos/systemuicommon/src/main/ets/vm/StatusBarIconConfig';
// instrument ignore file

const TAG = 'StatusBarIconListVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

// 默认允许显示的图标集合
const iconSwitchIsOnDefaultSlot: Set<string> = new Set([
  PluginSlot.LIVE_VIEW_CAPSULE,
  PluginSlot.SLOT_STATUS_CLOCK,
  PluginSlot.SLOT_STATUS_NOTIFICATION,
  PluginSlot.SLOT_STATUS_BATTERY,
  PluginSlot.SLOT_STATUS_SIGNAL,
  PluginSlot.SLOT_STATUS_OPERATOR,
]);

// 状态栏类型决定的图标过滤规则
const statusBarTypeExcludeSlot: Map<StatusBarType, string[]> = new Map([
  [StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, [PluginSlot.SLOT_STATUS_OPERATOR]],
  [StatusBarType.TYPE_MAIN_PHONE_DROPDOWN, [PluginSlot.SLOT_STATUS_CLOCK, PluginSlot.SLOT_STATUS_NOTIFICATION]],
  [StatusBarType.TYPE_MAIN_PHONE_KEYGUARD, [PluginSlot.SLOT_STATUS_OPERATOR, PluginSlot.SLOT_STATUS_CLOCK,
    PluginSlot.SLOT_STATUS_NOTIFICATION]],
]);

@ObservedV2
export class StatusBarIconListVm extends StatusBarBaseVm implements IStatusBarIconListVm {

  public rightIcons: PluginInfo[] = [];

  @Trace public leftIcons: PluginInfo[] = [];

  public middleIcons: PluginInfo[] = [];

  public envVm = EnvVm.instance;

  @Trace public contentColor: string = '#FFFFFF';

  @Trace public statusBarType: number = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;

  @Trace public isRenderGroupEnable: boolean = true;

  @Trace public moveDownVm: StatusBarMoveDownVmV2 = StatusBarMoveDownVmV2.getInstance();

  @Trace public deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;

  @Trace public resourceVm: ResourceVm = ResourceVm.instance;

  /**
   * 逻辑上允许显示的图标
   */
  @Trace public iconSwitchOnInfo: Set<string> = iconSwitchIsOnDefaultSlot;

  private eventMgr: EventManager = EvtBus.createEventManager();

  init(): void {
    log.showInfo(`StatusBarIconListVm init`);
    StatusBarIconConfig.instance.init();
    this.initIcons();
    this.initEvents();
  }

  public onPluginRequestEvent = (event: PluginRequestEvent): void => {
    if (!event.pluginSlot) {
      return;
    }
    log.showInfo(`requestEvent: ${event.pluginSlot}-${event.isVisible()}`);
    let iconVm: IStatusBarIconVm = this.vmInjector.getStatusBarIconVm(event.pluginSlot);
    if (!iconVm) {
      return;
    }
    if (event.isVisible()) {
      iconVm.isOnTheTree = true;
      this.iconSwitchOnInfo.add(event.pluginSlot);
    } else {
      this.iconSwitchOnInfo.delete(event.pluginSlot);
    }
    log.showInfo(`icon visible: ${iconVm.pluginName}, event.isVisible: ${event.isVisible()}`);
    setTimeout(()=>{
      this.vmInjector.getStatusBarLayoutVm().recalculateBaseLayout();
    }, 0)
  };

  public onIconVisibleSizeChange = (oldValue: SizeOptions, newValue: SizeOptions, pluginName: string) => {
    let iconVm = this.vmInjector.getStatusBarIconVm(pluginName);
    let val = newValue.width as number;
    log.showInfo(`sizechange slot: ${pluginName}, old: ${oldValue.width}, new: ${newValue.width}, vmWidth: ${iconVm.width}`);
    this.updateAodRect(pluginName);
    let oldVal = oldValue.width as number;
    // 设置图标为0的时候，可能引起其他图标1px的误差，导致重复计算
    if (Math.abs(val - oldVal) > ArkUIAdapter.px2vp(1.5)) {
      iconVm.width = val > 0 ? val : iconVm.width; // 防止出现负值
      // 无孔场景才会有胶囊的sizeChange，但是触发后不用更新状态栏布局，因为胶囊内部宽度变化后会有回调，在回调中处理布局更新
      if (pluginName === PluginSlot.LIVE_VIEW_CAPSULE) {
        return;
      }
      setTimeout(()=>{
        this.vmInjector.getStatusBarLayoutVm().recalculateBaseLayout();
      }, 0)
    }
  };

  // pocket产品需要更新胶囊和通知图标组件区域便于AOD截图，其他产品不需要，此处使用一个空实现，方便继承
  protected updateAodRect(pluginName: string): void { }

  @Monitor('statusBarType')
  statusBarTypeChangeVisible(monitor: IMonitor): void {
    log.showInfo(`statusBarType change from ${monitor.value()?.before}  to ${monitor.value()?.now}`)
    this.onStatusBarTypeChange();
  }

  protected onStatusBarTypeChange(): void {
    let event = new StatusBarTypeChangeEvent();
    event.statusBarType = this.statusBarType;
    EvtBus.post(StatusBarTypeChangeEvent, event);
    this.vmInjector.getStatusBarLayoutVm().recalculateBaseLayout();
  }

  @Monitor('moveDownVm.isMoveDown')
  moveDownStateChange(monitor: IMonitor): void {
    if (DropDownPanelManager.isPanelDismissing()) {
      return;
    }
    this.vmInjector.getStatusBarLayoutVm().recalculateBaseLayout();
  }

  @Monitor('deviceInfoVm.xtLayoutType', 'deviceInfoVm.orientation', 'resourceVm.isRTL')
  reSortLeftPlugins(): void {
    if (!LayoutUtils.isXTProductType()) {
      return;
    }
    const live = this.leftIcons.find((plugin) => plugin.pluginParseInfo.pluginSlot === PluginSlot.LIVE_VIEW_CAPSULE);
    if (!live) {
      return;
    }
    // XT设备G态通知图标和胶囊优先级可能动态变化
    if (this.deviceInfoVm.isXTLandscapeInvertedStatus() && !this.resourceVm.isRTL) {
      live.pluginParseInfo.pluginPriority = 4;
    } else {
      live.pluginParseInfo.pluginPriority = 2.5;
    }
    this.sortPluginArray(this.leftIcons, true);
  }

  // 锁屏覆盖场景，需要单独显示时间
  @Monitor('envVm.isOccluded')
  onIsOccluded():void {
    log.showInfo(`onIsOccluded this.envVm.isOccluded ${this.envVm.isOccluded}`);
    this.setOccludeKeyguard(this.envVm.isOccluded);
    let excludeSlot = statusBarTypeExcludeSlot.get(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD);
    if (!excludeSlot) {
      return;
    }
    let index = excludeSlot.indexOf(PluginSlot.SLOT_STATUS_CLOCK);
    if (index !== -1 && this.envVm.isOccluded) {
      excludeSlot.splice(index, 1);
    } else if (index === -1) {
      excludeSlot.push(PluginSlot.SLOT_STATUS_CLOCK);
    }
    statusBarTypeExcludeSlot.set(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD, excludeSlot);
  }

  private initIcons() {
    const plugins = StatusBarIconConfig.instance.createStatusBarIconList();
    plugins.forEach((pluginInfo) => {
      const pluginName = pluginInfo.pluginParseInfo.pluginSlot;
      log.showInfo(`slot: ${pluginInfo.pluginParseInfo.pluginSlot}, position: ${pluginInfo.pluginParseInfo.pluginPosition}, priority: ${pluginInfo.pluginParseInfo.pluginPriority}`);
      if (pluginName === PluginSlot.LIVE_VIEW_CAPSULE) {
        pluginInfo.pluginParseInfo.pluginPosition = PluginPosition.POSITION_LEFT;
        // 无孔场景胶囊处于时间（优先级为2）和通知图标（优先级为3）中间，更新优先级，保证排序正确
        pluginInfo.pluginParseInfo.pluginPriority = 2.5;
      }
      this.eventMgr.on(PluginRequestEvent, this.onPluginRequestEvent, pluginName);
      pluginInfo.pluginParseInfo.pluginIconWidth = DEFAULT_ICON_WIDTH_MAP.get(pluginName) ?? -1;
      if (pluginInfo.pluginParseInfo.pluginPosition === PluginPosition.POSITION_LEFT) {
        this.leftIcons.push(pluginInfo);
      } else if (pluginInfo.pluginParseInfo.pluginPosition === PluginPosition.POSITION_RIGHT) {
        this.rightIcons.push(pluginInfo);
      } else {
        this.middleIcons.push(pluginInfo);
      }
    })

    this.sortPluginArray(this.leftIcons, true);
    this.sortPluginArray(this.rightIcons, true);
    this.sortPluginArray(this.middleIcons);
  }

  private sortPluginArray(pluginArray: PluginInfo[], isReverse: boolean = false) {
    // 优先级排序
    pluginArray.sort((info1, info2): number => {
      if (isReverse) {
        return info1.pluginParseInfo.pluginPriority - info2.pluginParseInfo.pluginPriority;
      }
      return info2.pluginParseInfo.pluginPriority - info1.pluginParseInfo.pluginPriority;
    });
  }

  /*
  锁屏覆盖场景，更新图标显示规则
   */
  private setOccludeKeyguard(isLockInApp: boolean) {
    const settingVm = this.vmInjector.getStatusBarSettingVm();
    settingVm.isLockInApp = isLockInApp;
    this.vmInjector.getStatusBarLayoutVm().recalculateLayout(false);
  }

  private initEvents() {
  }

  /**
   * 获取排除槽位
   *
   * @param statusbarType 状态栏类型
   * @returns 排除槽位列表
   */
  public getExcludeSlotList(statusbarType: number): string[] | undefined {
    return statusBarTypeExcludeSlot.get(statusbarType);
  }

  /**
   * 获取图标布局描点
   */
  public getLeftIconAnchorInfo(pluginName: string): string {
    const isXTDevice = LayoutUtils.isXTProductType();
    const layoutVm = this.vmInjector.getStatusBarLayoutVm();
    // G态 挖孔在左上角场景，胶囊通知图标顺序跳转
    if (isXTDevice && this.deviceInfoVm.xtLayoutType === XTLayoutType.G &&
      this.deviceInfoVm.orientation === display.Orientation.LANDSCAPE_INVERTED &&
    !this.resourceVm.isRTL) {
      if (pluginName === PluginSlot.SLOT_STATUS_NOTIFICATION) {
        return this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK).id;
      }
      if (pluginName === PluginSlot.LIVE_VIEW_CAPSULE) {
        // 该形态的胶囊，位置需要一致保持在挖孔右侧，所以坐标与父节点绑定，单独通过定制化控制调整其位置
        return STATUS_BAR_LAYOUT_DEFAULT_ANCHOR;
      }
    }
    if (pluginName === PluginSlot.SLOT_STATUS_OPERATOR || pluginName === PluginSlot.SLOT_STATUS_CLOCK) {
      // 运营商和时间是基于根节点对齐
      return STATUS_BAR_LAYOUT_DEFAULT_ANCHOR;
    }

    if (pluginName === PluginSlot.LIVE_VIEW_CAPSULE) {
      // 及时胶囊 运营商显示时绑定运营商
      const hasInstant = LiveVmInjectorFactory.get().getCapsuleListVm().liveList.some((live) => live.isInstant());
      if (hasInstant && layoutVm.layoutIsVisibleIcons.has(PluginSlot.SLOT_STATUS_OPERATOR)) {
        return this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_OPERATOR).id;
      } else {
        return this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK).id;
      }
    }
    if (pluginName === PluginSlot.SLOT_STATUS_NOTIFICATION) {
      // 通知图标 中挖孔场景绑定时间、非中挖孔场景绑定胶囊
      if (CutoutVm.instance.isMiddleCutout()) {
        return this.vmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK).id;
      }
      return this.vmInjector.getStatusBarIconVm(PluginSlot.LIVE_VIEW_CAPSULE).id;
    }
    return STATUS_BAR_LAYOUT_DEFAULT_ANCHOR;
  }

  /**
   * 获取图标前一个图标
   */
  public getRightIconAnchorInfo(checkPluginName: string): string {
    let findSelf = false;
    for (let pluginInfo of this.rightIcons) {
      const pluginName = pluginInfo.pluginParseInfo.pluginSlot;
      if (pluginName === checkPluginName) {
        findSelf = true;
      } else if (findSelf && this.vmInjector.getStatusBarLayoutVm().layoutIsVisibleIcons.has(pluginName)) {
        const anchorIconVM = this.vmInjector.getStatusBarIconVm(pluginName)
        if (anchorIconVM) {
          return anchorIconVM.id;
        }
      }
    }
    return STATUS_BAR_LAYOUT_DEFAULT_ANCHOR;
  }
}