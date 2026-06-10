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

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  PluginSlot,
  ViewArea,
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  WindowPositionChangeEvent
} from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { USBController } from '@ohos/usbcomponent/src/main/ets/controller/USBController';
import { USBUtil } from '@ohos/usbcomponent/src/main/ets/common/USBUtil';
import { USBDeviceInfo } from '@ohos/usbcomponent/src/main/ets/common/USBDeviceInfo';
import { StatusBarPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import { baseStateMgr, LocalWindowManager } from '@ohos/systemuicommon';
import { LayoutViewModel } from '@ohos/launchercommon';
import { windowManager } from '@ohos/componentdrag';
import uiEffect from '@ohos.graphics.uiEffect';
import { PluginPosition } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';
import { MeasureUtils } from '@kit.ArkUI';

const TAG = 'USBPanel-Index';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const WINDOW_NAME = PluginSlot.SLOT_STATUS_USB;
const COMPONENT_ID_USB = TAG + '_Button_negative_';
const EXTERNAL_MNT_PATH_HEAD = '/mnt/data/external/';
const USB_LIST_HEIGHT = 40;
const USB_TITLE_WIDTH = 56;
// 亮色模式
const blender: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0,
  quadraticRate: 0,
  linearRate: 0.4,
  degree: -30 / 255,
  saturation: 1.8,
  positiveCoefficient: [1.9, 3.8, 1.3],
  negativeCoefficient: [0.5, 0.67, 1.3],
  fraction: 0
});
// 深色模式
const blenderDark: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0,
  quadraticRate: 0,
  linearRate: 1,
  degree: 133 / 255,
  saturation: 1.1,
  positiveCoefficient: [1, 1.2, 1],
  negativeCoefficient: [0.5, 1, 0.5],
  fraction: 0
});


@Component
export struct USBPanel {
  private eventMgr: EventManager = EvtBus.createEventManager();
  private viewCallback: ViewCallback = {
    onShow: () => this.onViewShow(),
    onHide: () => this.onViewHide()
  };
  @Provide persistentId: number = 0;
  @State viewController: PcStbSecondaryPanelController = new PcStbSecondaryPanelController(ViewType.PLUGIN_USB);
  @State panelInfo: StatusBarPanelInfo | undefined = undefined;
  @State isSelected: boolean = false;
  @State isHovered: boolean = false;
  @State mUSBController: USBController = USBController.getInstance();
  @StorageLink('USBList') @Watch('updateWindowHeight') mUSBList: Array<USBDeviceInfo> = [];
  /**
   * 存储设备复制粘贴过程中移除存储设备弹窗
   */
  storageDeviceUnmountDialog: CustomDialogController | undefined = undefined;

  handleStorageDeviceUnmountDialog(mUSBDeviceInfo: USBDeviceInfo): void {
    this.storageDeviceUnmountDialog = new CustomDialogController({
      /*builder: StorageDeviceUnmount({
        uuid: mUSBDeviceInfo.uuid,
        forcedRemove: (uuid: string) => {
          this.mUSBController.deleteCurUSB(mUSBDeviceInfo);
        }
      }),*/
      builder: {},
      autoCancel: false,
      alignment: DialogAlignment.Center,
      showInSubWindow: true,
    });
    this.storageDeviceUnmountDialog.open();
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear, start');
    viewMgrPolicy.registerViewController(ViewType.PLUGIN_USB, this.viewController);
    this.viewController.registerCallback(this.viewCallback);
    this.viewController.updateId(this.persistentId);
    this.viewController.registerFocusCallback();
    this.updateAreaAndRect();
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId);
  }

  updateAreaAndRect() {
    // 状态栏dock高度
    let pcDockHeight: number = LayoutViewModel.getInstance().getDockHeight();
    // pc整个屏幕的高度
    let PC_WHOLE_HEIGHT: number = windowManager.getWindowHeight();
    // usb列表高度;
    let USB_PANEL_HEIGHT: number = this.getUSBPanelHeight();

    let rect: ViewArea =
        {
          // 保持不变，和图标位置垂直
          left: this.viewController.getArea().left,
          // pc整屏幕高度 - 预留8 - 底部dock -usb列表高度
          top: PC_WHOLE_HEIGHT - 8 - pcDockHeight - USB_PANEL_HEIGHT,
          width: LocalWindowManager.PC_TRAY_PANEL_WIDTH,
          // usb列表高度
          height: USB_PANEL_HEIGHT,
        }
    this.viewController.updateArea(rect);
    this.viewController.updateRect(rect);
    log.showInfo('init USB panel end');
  }

  getUSBPanelHeight(): number {
    // 标题56 + 列表*40 + 列表间间距 （n-1）*2 + 列表底部边距4
    return USB_TITLE_WIDTH + this.mUSBList.length * USB_LIST_HEIGHT + this.mUSBList.length * 2 + 2 + 1;
  }

  updateWindowHeight() {
    let USB_PANEL_HEIGHT: number = this.getUSBPanelHeight();
    let position = windowMgr.getWindowPosition(WINDOW_NAME);
    position.height = vp2px(USB_PANEL_HEIGHT);
    EvtBus.post(WindowPositionChangeEvent, {
      windowName: WINDOW_NAME,
      position: PluginPosition.POSITION_RIGHT,
      area: position
    });
    log.showInfo(`new USB panel height(${USB_PANEL_HEIGHT}), flush end`);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
    this.viewController.unRegisterCallback(this.viewCallback);
    this.viewController.unRegisterFocusCallback();
    viewMgrPolicy.unregisterViewController(ViewType.PLUGIN_USB);
  }

  private onViewShow(): void {
    log.showInfo('usb show! amount: ' + this.mUSBList.length);
  }

  private onViewHide(): void {
    log.showInfo('usb hide!');
  }

  build() {
    Scroll() {
      Column() {
        Row() {
          Blank()
            .width(24)
          Text($r('app.string.usb_hover'))
            .fontWeight(FontWeight.Bold)
            .fontSize($r('sys.float.Title_S'))
            .focusable(false)
            .textAlign(TextAlign.Start)
            .fontColor($r('app.color.brightness_color'))
            .advancedBlendMode(baseStateMgr.isDarkMode() ? blenderDark : blender, BlendApplyType.FAST)
        }
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height(USB_TITLE_WIDTH)

        List({ space: 2 }) {
          ForEach(this.mUSBList, (mUSBDeviceInfo: USBDeviceInfo, index: number) => {
            ListItem() {
              USBComponent({
                wUSBDeviceInfo: mUSBDeviceInfo,
                index: index,
                onClickFunc: () => {
                  this.deleteCurUSB(mUSBDeviceInfo);
                },
              })
            }
          })
        }
        .margin({ bottom: 4 })
      }
      .width(LocalWindowManager.PC_TRAY_PANEL_WIDTH)
      .backgroundEffect({
        radius: baseStateMgr.isDarkMode() ? 120 : 100
      })

    }
    .borderRadius(this.panelInfo?.panelRadius)
    .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
  }

  deleteCurUSB(mUSBDeviceInfo: USBDeviceInfo) {
    log.showInfo(`deleteCurUSB: ${mUSBDeviceInfo.description}`);
    let isUsbInUse: boolean = false;
    let path: string = mUSBDeviceInfo.path ??
      `${EXTERNAL_MNT_PATH_HEAD}${USBUtil.isMtpDeviceByDeviceId(mUSBDeviceInfo.volumeId) ? mUSBDeviceInfo.volumeId :
      mUSBDeviceInfo.uuid}`;
    try {
      log.showInfo('queryUsbIsInUse begin');
      // isUsbInUse = filemanager.queryUsbIsInUse(path);
      log.showInfo(`remove usb inUse is : ${isUsbInUse}`);
    } catch (e) {
      log.error(`queryUsbIsInUse error:${e}`);
    }
    if (isUsbInUse) {
      this.handleStorageDeviceUnmountDialog(mUSBDeviceInfo);
      return;
    }

    this.mUSBController.deleteCurUSB(mUSBDeviceInfo);
    log.showInfo('flush usbList');
  }
}

@Component
export struct USBComponent {
  @State wUSBDeviceInfo: USBDeviceInfo | undefined = undefined;
  private index: number = 0;
  @State showUSBNamePopup: boolean = false;
  onClickFunc: Function = () => {
  };
  // 是否被截断
  @State isClipped: boolean = false;
  @State uiContext: UIContext = this.getUIContext();
  @State uiContextMeasure: MeasureUtils = this.uiContext.getMeasureUtils();

  build() {
    Row() {
      SymbolGlyph($r('sys.symbol.externaldrive'))
        .draggable(false)
        .fontSize('24vp')
        .fontColor([$r('app.color.brightness_color')])
        .advancedBlendMode(baseStateMgr.isDarkMode() ? blenderDark : blender, BlendApplyType.FAST)
        .fontWeight(FontWeight.Medium)
        .focusable(false)

      Blank()
        .width(12)

      Text(this.wUSBDeviceInfo?.description)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('app.color.brightness_color'))
        .advancedBlendMode(baseStateMgr.isDarkMode() ? blenderDark : blender, BlendApplyType.FAST)
        .fontWeight(FontWeight.Medium)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .focusable(false)
        .textAlign(TextAlign.Start)
        .layoutWeight(1)
        // 根据onAreaChange获取text组件的实际宽度
        .onAreaChange((oldValue: Area, newValue: Area) => {
          if (oldValue.width === newValue.width) {
            return;
          }
          // 计算当前设备的文本长度
          const metrics = Math.ceil(px2vp(this.uiContextMeasure.measureText({
            textContent: this.wUSBDeviceInfo?.description,
            fontSize: $r('sys.float.ohos_id_text_size_body1')
          })));
          // 文本宽度大于text组件则显示气泡
          this.isClipped = metrics > newValue.width;
          log.showInfo(`${this.wUSBDeviceInfo?.description} isClipped: ${this.isClipped}`);
        })
        .onHover((isHover: boolean) => {
          this.showUSBNamePopup = this.isClipped && isHover;
        })
        .bindPopup(this.showUSBNamePopup, {
          message: this.wUSBDeviceInfo?.description,
          placement: Placement.Bottom,
          enableArrow: false,
          popupColor: baseStateMgr.isDarkMode() ?
          $r('sys.color.ohos_id_blur_style_component_ultra_thick_color_dark') :
          $r('sys.color.ohos_id_blur_style_component_ultra_thick_color'),
          mask: false,
        })

      Blank()
        .width(12)

      Button($r('app.string.USBRemoved'))
        .fontSize($r('sys.float.Body_M'))
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi')
        .fontColor(baseStateMgr.isDarkMode() ? $r('sys.color.font_primary') : $r('sys.color.font_emphasize'))
        .controlSize(ControlSize.SMALL)
        .id(COMPONENT_ID_USB + this.index)
        .borderRadius(8)
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => {
          this.delete();
        })
    }
    .padding({ left: 24, right: 24 })
    .width('100%')
    .height(USB_LIST_HEIGHT)
  }

  delete() {
    this.onClickFunc();
  }
}


