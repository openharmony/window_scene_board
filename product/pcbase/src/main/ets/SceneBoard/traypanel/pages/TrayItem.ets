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
import { LogDomain, LogHelper, ArrayUtils } from '@ohos/basicutils';
import {
  ResourceManager,
  PluginSlot,
  viewMgrPolicy,
  ViewType,
} from '@ohos/frameworkwrapper';
import { ResUtils, windowMgr } from '@ohos/windowscene';
import { PluginProperty } from '@ohos/statusbarcomponent/src/main/ets/pc/viewdata/PluginProperty';
import sEventHandler from '@ohos/statusbarcomponent/src/main/ets/pc/manager/StatusBarEventPoster';
import { AnimManager, AnimProperty } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/AnimManager';
import { PluginStyle } from '@ohos/statusbarcomponent/src/main/ets/pc/style/PluginStyle';
import { StateManager, StateProperty } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/StateManager';
import { StyleManager } from '@ohos/statusbarcomponent/src/main/ets/pc/style/PluginStyleManager';
import bundleManager from '@ohos.bundle.bundleManager';
import { PcPluginRootComponent } from '@ohos/statusbarcomponent/src/main/ets/pc/pages/PcPluginRootComponent';
import { PcCapsuleComponent } from '@ohos/statusbarcomponent/src/main/ets/pc/pages/PcCapsuleComponent';
import { GroupStyle } from '@ohos/statusbarcomponent/src/main/ets/pc/style/PcStatusBarGroupStyle';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { PcStatusBarDragMgr } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/PcStatusBarDragMgr';
import { StyleType } from '@ohos/statusbarcomponent/src/main/ets/pc/utils/enum';
import { Constants } from '@ohos/statusbarcomponent/src/main/ets/pc/common/Constants';
import { PluginPositionType } from '@ohos/statusbarcomponent/src/main/ets/pc/common/PluginConstants';

const TAG = 'TrayItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export struct TrayItem {
  @StorageLink('systemLanguage') @Watch('onLanguageChange') language: string = '';
  @State @Watch('getPluginName') property: PluginProperty | undefined = undefined;
  /**
   * group样式
   */
  @State groupStyle: GroupStyle | null = null;
  @State stateProperty: StateProperty | null = null;
  @State animProperty: AnimProperty | undefined = undefined;
  @State pluginStyle: PluginStyle | null = null;
  @State trayItemName: string = 'fail';
  @State pluginSlot: string = '';
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  visibleCallback: Function | null = null;
  /**
   * 托盘定时器
   */
  private hideTrayTimer: number = -1;

  aboutToAppear() {
    this.pluginSlot = this.property?.getSlot() ?? '';
    this.animProperty = AnimManager.getInstance().getAnim(this.property?.getSlot()!);
    this.stateProperty = StateManager.getInstance().getState(this.property?.getSlot()!);
    this.pluginStyle = StyleManager.getInstance()
      .requestStyle(StyleType.PLUGIN, this.property?.getSlot() ?? '') as PluginStyle;
    this.getPluginName();
    this.groupStyle = StyleManager.getInstance()
      .requestStyle(StyleType.GROUP, PluginPositionType[PluginPositionType.BOTTOM_RIGHT]) as GroupStyle;
    log.showInfo(`aboutToAppear trayItemName: ${this.trayItemName} pluginSlot: ${this.pluginSlot}`);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear trayItemName: ${this.trayItemName} pluginSlot: ${this.pluginSlot}`);
  }

  build() {
    GridItem() {
      PcCapsuleComponent({
        pluginInfo: this.property?.pluginInfo,
        property: this.property,
        groupStyle: this.groupStyle,
        isTray: true,
      }) {
        PcPluginRootComponent({
          // 根组件唯一标示
          rootParentId: 'TrayPanel-Index',
          // plugin数据
          property: this.property,
          isGroupPlugin: false,
          isTray: true,
        })
      }
    }
    .id('GridItem' + this.trayItemName)
    .visibility(this.property?.isVisible() ? Visibility.Visible : Visibility.Hidden)
    .width(Constants.TRAY_ITEM_WIDTH)
    .height(Constants.TRAY_ITEM_HEIGHT)
    .pluginEventReceiver()
  }

  onLanguageChange(): void {
    this.language = AppStorage.get<string>('systemLanguage') as string;
    this.getPluginName();
  }

  private getPluginName(): void {
    switch (this.pluginSlot) {
      case PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE:
        this.trayItemName = ResUtils.getInnerStringByName('multispace_enterprise');
        break;
      case PluginSlot.SLOT_STATUS_MICROPHONE_PANEL:
        this.trayItemName = ResUtils.getInnerStringByName('microphone');
        break;
      case PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE:
        this.trayItemName = ResUtils.getInnerStringByName('not_disturb_title');
        break;
      case PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE:
        this.trayItemName = ResUtils.getInnerStringByName('super_privacy_toggle');
        break;
      case PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT:
        this.trayItemName = ResUtils.getInnerStringByName('super_privacy_toggle');
        break;
      case PluginSlot.SLOT_STATUS_SMART_SCREENSHOT:
        this.trayItemName = ResUtils.getInnerStringByName('smart_screenshot');
        break;
      default:
        this.updatePluginName();
    }
  }

  private updatePluginName(): void {
    let appName = 'fail';
    let resourceManager = ResourceManager.getInstance();
    let bundleName = this.property?.pluginInfo?.pluginParseInfo.bundleName;
    let moduleName = this.property?.pluginInfo?.pluginParseInfo.moduleName;
    let hapBundleFlags: number = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE
    let appBundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
    let appIndex = this.property?.pluginInfo?.pluginParseInfo.appIndex;
    try {
      let bundleInfo = bundleManager.getBundleInfoSync(bundleName, appBundleFlags);
      resourceManager.getAppNameWithCache(bundleInfo.appInfo.labelId, bundleName, moduleName, appName,
        (name: string) => {
          if (name !== appName) {
            this.trayItemName = name;
          }
          bundleManager.getBundleInfo(bundleName, hapBundleFlags).then((bundleInfo) => {
            let hapModuleInfos = bundleInfo.hapModulesInfo;
            log.showInfo(`trayItemName:${this.trayItemName}, appName:${appName}, bundleName:${bundleName}, appIndex:${appIndex}`);
            for (let i: number = 0; i < hapModuleInfos.length; ++i) {
              let moduleInfo = hapModuleInfos[i];
              if (moduleInfo.name === moduleName) {
                resourceManager.getAppNameWithCache(moduleInfo.labelId, bundleName, moduleName, appName,
                  (name: string) => {
                    if (name !== appName) {
                      this.trayItemName = name;
                    }
                  }, appIndex);
              }
            }
          })
        }, appIndex);
    } catch (err) {
      log.error(`bundleName:${bundleName}, updatePluginName error:`, err);
    }
    log.showInfo(`updatePluginName trayItemName:${this.trayItemName}, appName:${appName}, appIndex:${appIndex}`);
  }

  @Styles
  pluginEventReceiver(): void {
    .onMouse((event) => {
      sEventHandler.getInstance().postMouseEvent(event, this.property!.getSlot(), this.property!.getSlot());
    })
    .onTouch((event) => {
      sEventHandler.getInstance().postTouchEvent(event, this.property!.getSlot(), this.property!.getSlot());
    })
    .onHover((isHovered: boolean, event: HoverEvent) => {
      const isDragging: boolean = PcStatusBarDragMgr.getInstance().isStatusBarDragging;
      log.showInfo(`isDragging ${isDragging}`);
      if (isDragging) {
        log.showInfo('enter into Hover');
        return;
      }
      sEventHandler.getInstance()
        .postHoverEvent(event, this.property!.getSlot(), this.property!.getSlot(), isHovered);
    })
    .onClick((event: ClickEvent) => {
      sEventHandler.getInstance().postClickEvent(event, this.property!.getSlot(), this.property!.getSlot());
    })
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        LongPressGesture({ repeat: false })
          .onAction((event) => {
            sEventHandler.getInstance()
              .postLongClickEvent(event, this.property!.getSlot(), this.property!.getSlot());
          })
      )
    )
  }

  private async hideTrayPanel(event: MouseEvent): Promise<void> {
    if (event.button === MouseButton.Left && event.action === MouseAction.Press && this.isInIconArea(
      event.windowX as number, event.windowY as number, this.property?.area as Area)) {
      // 这里加时延是因为，图标在托盘窗口里，事件冒泡从父组件到子组件，这里直接hide，会导致子组件收不到事件
      // 150ms跟窗口onTouchOutSide时延一致
      clearTimeout(this.hideTrayTimer);
      this.hideTrayTimer = setTimeout(() => {
        if (viewMgrPolicy.isViewShowing(ViewType.TRAY_PANEL)) {
          windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL);
        }
      }, 300);
    }
  }

  private async hideTrayPanelByTouch(event: TouchEvent): Promise<void> {
    if (event.type === TouchType.Up && !ArrayUtils.isEmpty(event.touches)) {
      log.showInfo('hideTrayPanelByTouch begin');
      // 这里加时延是因为，图标在托盘窗口里，事件冒泡从父组件到子组件，这里直接hide，会导致子组件收不到事件
      // 150ms跟窗口onTouchOutSide时延一致
      clearTimeout(this.hideTrayTimer);
      this.hideTrayTimer = setTimeout(() => {
        if (viewMgrPolicy.isViewShowing(ViewType.TRAY_PANEL)) {
          windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL);
        }
      }, 200);
      log.showInfo('hideTrayPanelByTouch end');
    }
  }

  private isInIconArea(x: number, y: number, iconArea: Area): boolean {
    let tmp = iconArea.globalPosition;
    if (x >= (tmp.x as number) && x <= ((tmp.x as number +
      ((iconArea as Area).width as number))) && y >= (tmp.y as number) &&
      y <= ((tmp.y as number + ((iconArea as Area).height as number)))) {
      return true;
    }
    return false;
  }
}