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

import { CommonUtils, Log, } from '@ohos/basicutils';
import { MultiKeyCode, MultimodalInputManager, styleMgr } from '@ohos/systemuicommon';
import { StyleConstants } from '@ohos/launchercommon';
import {
  WindowPositionChangeEvent,
  WindowEvent,
  ScreenOnOffEvent,
  RequestWindowEvent,
  AccessPanelHeightChangeEvent,
  ViewManagerPolicy,
  PluginAccessInfo,
  ViewArea,
  PluginWindowType,
  EvtBus,
  EventManager,
} from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import { StyleConstant } from '../../common/constants/StyleConstants';
import { window } from '@kit.ArkUI';
import { PcStbSecondaryPanelController } from '../controller/PcStbSecondaryPanelController';
import { ComponentContent } from '@kit.ArkUI';

const TAG = 'DynamicPluginAccessComponent';

@Component
export struct DynamicPluginAccessComponent {
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private pluginInfo: PluginAccessInfo | null = null;
  private windowMaxHeight: number = 0;
  persistentId: number = 0;
  /**
   * AbilityComponent组件ability名
   */
  private pluginAbilityName: string = '';
  /**
   * AbilityComponent组件包名
   */
  private pluginBundleName: string = '';
  private pluginModuleName: string = '';
  @StorageProp('screenHeight') screenHeight: number = 0;
  @StorageProp('dockHeight') dockHeight: number = 0;
  @State @Watch('onViewDataChange') pluginPanelCtrl: PcStbSecondaryPanelController = new PcStbSecondaryPanelController(TAG);
  @State windowHeight: number = 0;
  @State isShowing: boolean = false;
  @State isScrolling: boolean = false;
  @State pluginUri: string = 'load';
  @State canDestroy: boolean = true;
  @State loadingProgressStatus: boolean = false;

  /**
   * 关闭弹窗
   */
  private hideWindow(): void {
    if (!windowMgr.isShowing(this.pluginInfo?.getSlot())) {
      return;
    }
    windowMgr.hideWindowWithAnim(this.pluginInfo?.getSlot());
  }

  /**
   * 监听窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    // 非当前窗口，如果是开始展示则隐藏
    if (event.isWindowStartShow()) {
      Log.showInfo(TAG, `onWindowEvent ability: ${this.pluginInfo?.getSlot()}, event type is ${event.eventType}`);
      if (event.isMatchName(WindowConstants.WINDOW_NAME_BANNER)) {
        return;
      }
      if (!event.isMatchName(this.pluginInfo?.getSlot())) {
        this.hideWindow();
      }
    }
  }

  onRequestWindowHeightEvent(event: AccessPanelHeightChangeEvent): void {
    const height = this?.pluginInfo?.pluginParseInfo?.clickInfo?.windowHeight ?? -1;
    if (event.tokenId === this.pluginInfo?.accessTokenId &&
      event.instanceKey === this.pluginInfo?.pluginParseInfo?.instanceKey && height > -1) {
      const panelRect = this.pluginPanelCtrl.getArea();
      panelRect.height = event.windowHeight + StyleConstant.PC_STATUS_BAR_PANEL_TITLE_HEIGHT;
      this.windowHeight = panelRect.height;
      if (panelRect.height > this.windowMaxHeight) {
        panelRect.height = this.windowMaxHeight;
      }
      const computedTop = this.getPanelTopVP(panelRect.height);
      if (computedTop !== undefined) {
        panelRect.top = computedTop;
      }
      this.pluginPanelCtrl.updateArea(panelRect);
      this.pluginPanelCtrl.updateRect(panelRect);
      let area: window.Rect = {
        left: vp2px(panelRect.left),
        top: vp2px(panelRect.top),
        width: vp2px(panelRect.width),
        height: vp2px(panelRect.height)
      }
      EvtBus.post(WindowPositionChangeEvent,
        { windowName: this.pluginInfo?.getSlot(),
          position: this.pluginInfo?.pluginParseInfo.pluginPosition,
          area: area });
    }
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent(event: ScreenOnOffEvent): void {
    Log.showInfo(TAG, 'onScreenOnOffEvent');
    // 熄屏隐藏面板
    if (event.isScreenOff()) {
      // 提前隐藏弹框
      windowMgr.hideWindowImmediately(this.pluginInfo?.getSlot());
    }
  }

  private onRequestWindowEvent(event: RequestWindowEvent): void {
    Log.showInfo(TAG, `onRequestWindowEvent ${RequestWindowEvent.REQUEST_HIDE} window Policy ${event.windowName}}`);
    if (event.windowName === null && event.requestType === RequestWindowEvent.REQUEST_HIDE) {
      if (!windowMgr.isShowing(this.pluginInfo?.getSlot())) {
        return;
      }
      if (event.hasWindowAnim) {
        windowMgr.hideWindowWithAnim(this.pluginInfo?.getSlot());
      } else {
        windowMgr.hideWindowImmediately(this.pluginInfo?.getSlot());
      }
    }
  }

  /**
   * 初始化
   */
  private initWindowPolicy(): void {
    Log.showInfo(TAG, `init ${this.pluginInfo?.getSlot()} window Policy`);
    // 监听窗口事件
    this.eventMgr.on(WindowEvent, (event) => this.onWindowEvent(event))
      .on(ScreenOnOffEvent, (event) => this.onScreenOnOffEvent(event))
      .on(RequestWindowEvent, (event) => this.onRequestWindowEvent(event))
      .on(AccessPanelHeightChangeEvent, (event) => this.onRequestWindowHeightEvent(event))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }));
  }

  private getWindowHeight(): number {
    let height: number | undefined = this.pluginInfo?.pluginParseInfo?.clickInfo?.windowHeight;
    if (height) {
      height = height + StyleConstant.PC_STATUS_BAR_PANEL_TITLE_HEIGHT;
    } else {
      height = StyleConstant.PC_STATUS_BAR_PANEL_DEFAULT_HEIGHT;
    }
    return height;
  }

  private setWindowMaxHeight() {
    const statusBarHeight = styleMgr.px2vpStatusBarPCHeight();
    if (this.windowMaxHeight < 1 && this.screenHeight > 0 && statusBarHeight > 0 && this.dockHeight > 0) {
      const windowMaxHeight = this.screenHeight - statusBarHeight - this.dockHeight -
        StyleConstant.PC_STATUS_BAR_PANEL_MARGIN_BOTTOM;
      if (windowMaxHeight > 0) {
        this.windowMaxHeight = windowMaxHeight;
      }
    }
  }

  /**
   * 计算面板应显示的 top（vp），使面板紧贴状态栏上方，避免与状态栏重叠。
   * 首次打开时 getWindowPosition 可能未就绪，需用此结果校正位置。
   */
  private getPanelTopVP(panelHeightVP: number): number | undefined {
    const statusBarHeight = styleMgr.px2vpStatusBarPCHeight();
    if (this.screenHeight <= 0 || this.dockHeight < 0 || statusBarHeight <= 0) {
      return undefined;
    }
    return this.screenHeight - this.dockHeight - statusBarHeight - panelHeightVP -
      StyleConstant.PC_STATUS_BAR_PANEL_MARGIN_BOTTOM;
  }

  private getPanelHeight(): number {
    return this.windowHeight > this.windowMaxHeight ? this.windowMaxHeight : this.windowHeight;
  }

  aboutToAppear(): void {
    if (CommonUtils.isInvalid(this.pluginInfo)) {
      Log.showWarn(TAG, 'pluginInfo invalid');
      return;
    }
    this.setWindowMaxHeight();
    let pluginParseInfo = this.pluginInfo?.pluginParseInfo;
    this.pluginAbilityName = pluginParseInfo?.pluginAbilityName ?? '';
    this.pluginBundleName = pluginParseInfo?.bundleName ?? '';
    this.pluginModuleName = pluginParseInfo?.moduleName ?? '';
    if (CommonUtils.isEmpty(this.pluginInfo?.getSlot())) {
      Log.showWarn(TAG, 'pluginSlot invalid');
      return;
    }
    this.pluginPanelCtrl = new PcStbSecondaryPanelController(this.pluginInfo?.getSlot() ?? '');
    ViewManagerPolicy.registerViewController(this.pluginInfo?.getSlot(), this.pluginPanelCtrl);
    this.pluginPanelCtrl.updateId(this.persistentId);
    this.pluginPanelCtrl.registerFocusCallback();

    let clickInfo = pluginParseInfo?.clickInfo;
    this.initWindowPosition(clickInfo?.windowType ?? '');
    if (CommonUtils.isEmpty(this.pluginAbilityName) || CommonUtils.isEmpty(this.pluginBundleName)) {
      Log.showWarn(TAG, 'abilityName or bundleName invalid');
      return;
    }
    this.initWindowPolicy();
    statusbarPlCtrl.registerPanelName(this.pluginInfo?.getSlot() ?? '');
    this.loadingProgressStatus = this.pluginInfo!.loadingStatus;
  }

  aboutToDisappear(): void {
    Log.showInfo(TAG, 'aboutToDisappear');
    this.eventMgr.offAll();
    this.pluginPanelCtrl.unRegisterFocusCallback();
  }

  initWindowPosition(windowType: string): void {
    let windowWidth = PluginWindowType.getWindowWidth(windowType);
    if (windowWidth === 0) {
      Log.showWarn(TAG, 'window type invalid');
      return;
    }

    const oldPosition = windowMgr.getWindowPosition(this.pluginInfo?.getSlot());
    this.windowHeight = this.getWindowHeight();
    const panelHeight = this.getPanelHeight();
    const computedTop = this.getPanelTopVP(panelHeight);
    const topVP = computedTop !== undefined ? computedTop : px2vp(oldPosition.top);
    let rect: ViewArea = {
      left: px2vp(oldPosition.left),
      top: px2vp(topVP),
      width: px2vp(windowWidth),
      height: panelHeight
    };
    this.pluginPanelCtrl.updateArea(rect);
    this.pluginPanelCtrl.updateRect(rect);
    let area: window.Rect = {
      left: vp2px(rect.left),
      top: vp2px(rect.top),
      width: vp2px(rect.width),
      height: vp2px(rect.height)
    }
    EvtBus.post(WindowPositionChangeEvent,
      { windowName: this.pluginInfo?.getSlot(),
        position: this.pluginInfo?.pluginParseInfo.pluginPosition,
        area: area });
  }

  onViewDataChange() {
    if (this.isShowing) {
      return;
    }
    this.isShowing = this.pluginPanelCtrl.isShowing();
  }

  private isShowingComponent(): boolean {
    if (CommonUtils.isEmpty(this.pluginBundleName)) {
      return false;
    }
    if (CommonUtils.isEmpty(this.pluginAbilityName)) {
      return false;
    }
    if (this.isShowing) {
      return true;
    }
    if (this.canDestroy) {
      return false;
    }
    return true;
  }

  @Builder
  AccessPluginLoadingProgress() {
    LoadingProgress()
      .id('load_test_start_bar')
      .color($r('sys.color.ohos_id_color_progress'))
      .width(32)
      .height(32)
  }

  @Builder
  AccessPluginPanelTitle() {
    Column() {
      Row() {
        Text(this.pluginInfo?.title)
          .fontSize($r('sys.float.ohos_id_text_size_headline7'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .height(StyleConstant.PC_STATUS_BAR_PANEL_TITLE_TEXT_HEIGHT)
          .maxLines(StyleConstants.DEFAULT_1)
          .width(this.loadingProgressStatus ? StyleConstant.PC_STATUS_BAR_PANEL_TITLE_TEXT_WIDTH : '100%')
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Start)

        if (this.loadingProgressStatus) {
          Blank();
          this.AccessPluginLoadingProgress();
        }
      }
      .height(StyleConstant.PC_STATUS_BAR_PANEL_TITLE_HEIGHT)
      .width('100%')
      .padding({
        top: StyleConstant.PC_STATUS_BAR_TITLE_PADDING_TOP,
        left: StyleConstant.PC_STATUS_BAR_TITLE_PADDING_LEFT,
        right: StyleConstant.PC_STATUS_BAR_TITLE_PADDING_LEFT
      })
    }
  }

  private hidePluginPanel(keyEvent?: KeyEvent): void {
    const codeIsHide = keyEvent?.keyCode === MultiKeyCode.ESC ||
      keyEvent?.keyCode === MultiKeyCode.BACK || keyEvent?.type === KeyType.Up;
    if (this.pluginInfo?.getSlot() && codeIsHide) {
      windowMgr.hideWindowWithAnim(this.pluginInfo?.getSlot());
    }
  }

  private getInnerWindowHeight(): number {
    return this.windowHeight - StyleConstant.PC_STATUS_BAR_PANEL_TITLE_HEIGHT;
  }

  @Builder
  UIAccessPluginComponent() {
    UIExtensionComponent({
      bundleName: this.pluginBundleName,
      abilityName: this.pluginAbilityName,
      moduleName: this.pluginModuleName,
      parameters: {
        'ability.want.params.uiExtensionType': 'statusBarView'
      },
      uri: this.pluginUri
    },
      {
        dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI
      }
    )
      .id(TAG + '_' + this.pluginAbilityName)
      .onRelease((code: number) => {
        this.pluginUri = this.pluginUri === 'load' ? 'reLoad' : 'load';
        Log.showInfo(TAG, 'ability onRelease,code:%{public}d,uri, pluginUri:%{public}s', code, this.pluginUri);
      })
      .onError(err => {
        Log.showError(TAG, 'ability onError');
      })
      .onDrawReady(() => {
        this.loadingProgressStatus = false;
      })
      .onHover((isHover: boolean) => {
        this.isScrolling = (isHover && this.windowHeight > this.windowMaxHeight) ? true : false;
      })
      .backgroundColor('#00000000')
      .width('100%')
      .height(this.getInnerWindowHeight())
      .defaultFocus(true)
      .onKeyEvent((keyEvent?: KeyEvent) => {
        this.hidePluginPanel(keyEvent);
      });
  }

  build() {
    // 这里必须用if来控制，不能用.visibility，否则会预先加载打印机，导致状态栏出现打印机空胶囊
    if (this.isShowingComponent()) {
      Column() {
        this.AccessPluginPanelTitle();
        Stack({ alignContent: Alignment.TopStart }) {
          this.UIAccessPluginComponent();
        }
        .width('100%')
      }
      .justifyContent(FlexAlign.Start)
      .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
      .width('100%')
      .height(this.pluginPanelCtrl.getArea().height)
      .clip(true);
    }
  }
}