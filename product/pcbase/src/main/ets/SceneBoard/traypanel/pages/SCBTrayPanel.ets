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

import { LogHelper, LogDomain, Observer, } from '@ohos/basicutils';
import {
  PluginSlot,
  EvtBus,
  EventManager,
  WindowEvent,
  ScreenOnOffEvent,
  viewMgrPolicy,
  ViewArea,
  ViewType,
  PluginPosition,
  ConfigurationEvent,
  WindowPositionChangeEvent
} from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { MultimodalInputManager, MultiKeyCode } from '@ohos/systemuicommon';
import { LocalWindowManager } from '@ohos/systemuicommon';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import { StatusBarPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import { StatusBarTint } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarTint';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { PluginProperty } from '@ohos/statusbarcomponent/src/main/ets/pc/viewdata/PluginProperty';
import { PcTrayItemDropFrame } from '@ohos/statusbarcomponent/src/main/ets/pc/pages/PcTrayItemDropFrame';
import { PcStatusBarDragMgr } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/PcStatusBarDragMgr';
import curves from '@ohos.curves';
import { TrayItem } from './TrayItem';
import PcTrayGridLayoutUtil from '@ohos/statusbarcomponent/src/main/ets/pc/manager/PcTrayGridLayoutUtil';
import { TrayPanelController } from '../common/TrayPanelController';
import { trayPanelMenuVM } from '@ohos/statusbarcomponent/src/main/ets/pc/viewmodel/TrayPanelMenuVM';
import { PluginGroupingManager } from '@ohos/statusbarcomponent/src/main/ets/pc/plugingroup/PluginGroupingManager';
import { PluginGroupType, PluginPositionType } from '@ohos/statusbarcomponent/src/main/ets/pc/common/PluginConstants';
import { Constants } from '@ohos/statusbarcomponent/src/main/ets/pc/common/Constants';
import {
  PluginWindowManager
} from '@ohos/statusbarcomponent/src/main/ets/pc/pluginwindow/PluginWindowManager';
import { GroupProperty } from '@ohos/statusbarcomponent/src/main/ets/pc/plugingroup/viewdata/GroupProperty';

const TAG = 'TrayPanel-Index';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const TRAY_KEY = 'h1_systemUI_product_pc_trayPanel';
const LIGHT_COLOR: string = '#000000';
const DARK_COLOR: string = '#FFFFFF';

/**
 * 窗口名称
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_TRAY_PANEL;

@Component
export struct SCBTrayPanel {
  @Provide persistentId: number = 0;
  @State trayPanelCtrl: TrayPanelController = new TrayPanelController();
  @State panelInfo: StatusBarPanelInfo | undefined = undefined;
  @State @Watch('onTrayAreaChange') trayAreaPlugins: GroupProperty =
    PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT, PluginGroupType.TRAY);
  @State windowWidth: number = LocalWindowManager.PC_TRAY_PANEL_WIDTH;
  @State windowHeight: number = LocalWindowManager.PC_TRAY_PANEL_HEIGHT;
  @Provide contentColor: string = StatusBarTint.CONTENT_COLOR_BLACK;
  private screenLockObserver: Observer | null = null;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private showDropFrame: boolean = true;
  private itemRect: Rectangle = {
    x: 0,
    y: 0,
    width: 0,
    height: 0
  };
  @State gridWidth: number = 0;
  @State gridHeight: number = 0;
  @State gridColumns: number = Constants.MIN_COLUMNS;
  @State gridRows: number = Constants.MIN_ROWS;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    viewMgrPolicy.registerViewController(ViewType.TRAY_PANEL, this.trayPanelCtrl);
    this.trayPanelCtrl.updateId(this.persistentId);
    this.trayPanelCtrl.registerFocusCallback();
    this.trayPanelCtrl.registerTouchOutsideCallback(() => {
      return this.dealTrayPanelTouchOutSide();
    });
    // 初始化时需要根据当前显示图标数量更新组件的网格大小
    this.trayAreaChange(this.trayAreaPlugins.getVisualPluginNum());
    this.initWindowPolicy();
    // 窗口动画绑定onFrame
    windowMgr.startBindWinAnimOnFrame(WINDOW_NAME);

    // 锁屏监听
    this.screenLockObserver = {
      notify: (): void => {
        log.showInfo('onLockScreen');
        this.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId);
    PcStatusBarDragMgr.getInstance().registerTrayListNumChangeInDragCallback(this.onTrayListNumChangeInDrag);
  }

  private onTrayListNumChangeInDrag = (addTrayPlugNum: number): void => {
    log.showInfo(`onTrayListNumChangeInDrag length: ${this.trayAreaPlugins.getVisualPluginNum()}, addTrayPlugNum: ${addTrayPlugNum}`);
    this.onTrayAreaChangeExt(addTrayPlugNum);
  };

  onLockScreen(): void {
    this.hideWindow();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.eventMgr.offAll();
    this.trayPanelCtrl.unRegisterFocusCallback();
    windowMgr.offTouchOutside(WINDOW_NAME);
    if (this.screenLockObserver) {
      screenLockMediator.deleteObserver(this.screenLockObserver);
    }
    PcStatusBarDragMgr.getInstance().unregisterTrayListNumChangeInDragCallback();
  }

  @Styles
  dragStyle() {
    .onDragEnter((event: DragEvent, extraParams?: string) => {
      log.showInfo('onDragEnter');
    })
    .onDragMove((event: DragEvent, extraParams?: string) => {
      log.showInfo('onDragMove');
    })
    .onDrop((event?: DragEvent, extraParams?: string) => {
      log.showInfo('onDrop');
    })
    .onDragLeave((event: DragEvent, extraParams?: string) => {
      log.showInfo('onDragLeave');
      PcStatusBarDragMgr.getInstance().onDragLeaveTray(event, extraParams);
    })
  }

  build() {
    Column() {
      Stack() {
        PcTrayItemDropFrame()

        Grid() {
          ForEach(this.trayAreaPlugins.getVisualPluginList(), (property: PluginProperty) => {
            TrayItem({
              property: property,
            })
          }, (property: PluginProperty, index: number) => property.getSlot())
        }
        .width(this.gridWidth)
        .height(this.gridHeight)
        .margin({
          top: Constants.GRID_MARGIN_TB,
          bottom: Constants.GRID_MARGIN_TB,
          left: Constants.GRID_MARGIN_LR,
          right: Constants.GRID_MARGIN_LR,
        })
        .visibility(Visibility.Visible)
        .rowsGap(Constants.ROW_GAP)
        .columnsGap(Constants.COLUMN_GAP)
        .clip(false)
        .columnsTemplate(this.getGridTemplate(this.gridColumns))
        .rowsTemplate(this.getGridTemplate(this.gridRows))
      }
    }
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
    .width(this.windowWidth)
    .height(this.windowHeight)
    .key(TRAY_KEY)
    .clip(false)
    .borderRadius(this.panelInfo?.panelRadius)
    .dragStyle()
    .onMouse((event) => {
      if (event.action === MouseAction.Press) {
        if (trayPanelMenuVM.isHaveMenuOpen()) {
          trayPanelMenuVM.setNeedCloseTrayPanelThisTime(false);
        }
      }
    })
    .onTouch((event) => {
      // 防止因为手指点击托盘使得右键菜单消失时托盘直接关闭，
      if (event.type === TouchType.Down) {
        if (trayPanelMenuVM.isHaveMenuOpen()) {
          trayPanelMenuVM.setNeedCloseTrayPanelThisTime(false);
        }
      }
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.itemRect = {
        x: newValue.globalPosition.x,
        y: newValue.globalPosition.y,
        width: newValue.width,
        height: newValue.height
      };
    })
  }

  private initWindowPolicy() {
    log.showInfo(TAG, `init Battery panel window Policy`);
    // 窗口show/hide事件
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      this.onWindowEvent(event)
    })
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent) => {
        this.onScreenOnOffEvent(event)
      })
      .on(ConfigurationEvent, (event: ConfigurationEvent) => {
        this.onConfigurationEvent(event);
      })
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
  }

  /**
   * 属性切换事件回调
   *
   * @param event 事件
   */
  private onConfigurationEvent(event: ConfigurationEvent): void {
    if (!event) {
      log.showInfo('ConfigurationEvent undefined or null');
      return;
    }
    ;
    if (event.config?.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
      log.showError('colorMode not set');
      return;
    }
    log.showInfo('colorMode ' + event.config?.colorMode);
    let colorMode = event?.config?.colorMode;
    let isDark = (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) ?? false;
    if (isDark) {
      this.contentColor = DARK_COLOR;
    } else {
      this.contentColor = LIGHT_COLOR;
    }
  }

  /**
   * 窗口show/hide事件回调
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    if (event.isWindowStartShow()) {
      if (event.isMatchName(WindowConstants.WINDOW_NAME_BANNER)) {
        return;
      }
      if (!event.isMatchName(WINDOW_NAME)) {
        this.hideWindow();
      }
    }
  }

  private hideWindow(): void {
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      return;
    }
    log.showInfo(TAG, `hide anim start`);
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent(event: ScreenOnOffEvent): void {
    // 熄屏隐藏面板
    if (event.isScreenOff()) {
      // 提前隐藏弹框
      windowMgr.hideWindowImmediately(WINDOW_NAME);
    }
  }

  private onTrayAreaChange(): void {
    this.onTrayAreaChangeExt();
  }

  private onTrayAreaChangeExt(addNum: number = 0): void {
    if (!this.trayAreaPlugins) {
      log.showError('invalid trayArea');
      return;
    }
    this.trayAreaPlugins.getPluginList().forEach((plug: PluginProperty) => {
      log.showInfo('onTrayAreaChange trayArea plug:' + plug?.getSlot() + ', visible:' + plug?.isVisible());
    })
    let trayNum: number = this.trayAreaPlugins.getVisualPluginNum();
    if (trayNum === 0) {
      this.hideWindow();
      if (!PcStatusBarDragMgr.getInstance().isStatusBarDragging) {
        PcStatusBarDragMgr.getInstance().notifyShowArrowButton(false);
      }
    }
    if (trayNum > 0) {
      if (!PcStatusBarDragMgr.getInstance().isStatusBarDragging) {
        PcStatusBarDragMgr.getInstance().notifyShowArrowButton(true);
      }
    }
    if (PcStatusBarDragMgr.getInstance().isStatusBarDragging) {
      animateTo({
        curve: curves.interpolatingSpring(0, 1, 660, 66),
        onFinish: () => {
          PcStatusBarDragMgr.getInstance().isTrayAreaAnimateFinish = true;
        }
      }, () => {
        this.trayAreaChange(trayNum + addNum);
      })
    } else {
      this.trayAreaChange(trayNum + addNum);
    }
  }

  private setTrayPanelRect(trayNum: number): void {
    this.windowWidth = PcTrayGridLayoutUtil.getWindowWidth(trayNum);
    this.windowHeight = PcTrayGridLayoutUtil.getWindowHeight(trayNum);
    PluginWindowManager.getInstance().setTrayPanelRect(vp2px(this.windowWidth), vp2px(this.windowHeight));
  }

  private trayAreaChange(trayNum: number): void {
    this.setTrayPanelRect(trayNum);
    let area = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_TRAY_PANEL);
    log.showInfo(`trayAreaChange num:${trayNum}, winWidth:${this.windowWidth}, windowHeight:${this.windowHeight}`);
    let rect: ViewArea = {
      left: px2vp(area.left),
      top: px2vp(area.top),
      width: this.windowWidth,
      height: this.windowHeight
    };
    this.trayPanelCtrl.updateArea(rect);
    this.trayPanelCtrl.updateRect(rect);
    area.width = vp2px(this.windowWidth);
    area.height = vp2px(this.windowHeight);
    EvtBus.post(WindowPositionChangeEvent,
      { windowName: PluginSlot.SLOT_STATUS_TRAY_PANEL, position: PluginPosition.POSITION_RIGHT, area })

    this.gridColumns = PcTrayGridLayoutUtil.getCols(trayNum);
    this.gridRows = PcTrayGridLayoutUtil.getRows(trayNum);
    this.gridWidth = PcTrayGridLayoutUtil.getGridWidth(this.gridColumns);
    this.gridHeight = PcTrayGridLayoutUtil.getGridHeight(this.gridRows);
    PcTrayGridLayoutUtil.initGridPosition(this.gridRows, this.gridColumns);
  }

  private getGridTemplate(column: number): string {
    let template = '1fr';
    for (let i = 1; i < column; i++) {
      template += ' 1fr';
    }
    return template;
  }

  private dealTrayPanelTouchOutSide(): boolean {
    log.showInfo('deal TrayPanel TouchOutSide!');
    return !trayPanelMenuVM.isNeedCloseTrayPanel();
  }
}