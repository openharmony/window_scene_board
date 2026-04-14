/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { DcMediaController } from '../../Controller/DcMediaController';
import { CastDeviceControl } from '../../Controller/CastDeviceControl';
import { CastDeviceControlDc } from '../../Controller/CastDeviceControlDc';
import Constants, { DeviceSource, DeviceState, LocalDeviceInfo,
  AVCastPickerDeviceIconName, dmReplyData, dmReplyDataParam, ShowDevType } from '../../Util/Constants';
import display from '@ohos.display';
import MeasuringUtil from '../../Util/MeasuringUtil';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import audio from '@ohos.multimedia.audio';
import { BusinessError } from '@kit.BasicServicesKit';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import Curves from '@ohos.curves';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

const TAG: string = 'DeviceListCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const castPlusAudioType = 8;

@Component
export struct DeviceListCard {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private isPC: boolean = DeviceHelper.isPC() && !ControlCenterPluginMgr.isPcMode;
  @Prop curOutputDev: LocalDeviceInfo = {deviceId: -1, deviceType: -1};
  @Prop @Watch('setDeviceList') deviceList: Array<LocalDeviceInfo> = [];
  @Prop showDevType: ShowDevType = ShowDevType.MEDIA;
  @Link isExpand: boolean;
  @Link hideDeviceScroll: boolean;
  @Link dsControl: CastDeviceControl | CastDeviceControlDc | undefined;
  @Prop dcController: DcMediaController | undefined = undefined;
  @Link deviceDisable: boolean;
  @Prop curSessionId: string = '';
  @State selectMode: 'checkbox' | 'ok' | 'smallScreenDeviceList' = 'ok';
  @State prefix: string = '';
  @State isWifiActive: boolean = false;
  // 设备上下线
  @State deviceListCopy: LocalDeviceInfo[] = [...this.deviceList];
  // 本机设备
  @State localDeviceItem: LocalDeviceInfo | undefined = AppStorage.get('LocalDeviceItem');
  @State deviceListData: Array<LocalDeviceInfo> = [];
  @State listOpacity: number = 0;
  @State listScale: number = 0;
  @State listHeight: number = 0;
  @State onlineDeviceId: string | number | null = -1;
  private scroller: Scroller = new Scroller()
  @State loop: boolean = true;
  @State hookOpacity: number = 0;
  @State curIndex: number = -1;
  @State hookOpacityId: string | number | null = null;
  @State downHookOpacityId: string | number | null = null;
  // 折叠屏变量
  @State ret: boolean = false;
  @State isFolding: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State dmInstance: distributedDeviceManager.DeviceManager | undefined = undefined; // dm设备管理
  private dmBindTarget: string | number | undefined = undefined;
  @StorageLink('isSysColor') isSysColor: boolean = true;
  // 一镜到底动效是否完成
  @StorageLink('mediaTransitionDone') @Watch('transitionChange') mediaTransitionDone: boolean = false;
  @State localDeviceOpacity: number = this.mediaTransitionDone ? 0 : 1;
  @State deviceListItemOpacity: number = this.mediaTransitionDone ? 1 : 0;
  @State textMaxFontScale: number = Constants.TEXT_MAX_FONT_SCALE;
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false; // 增加UI缓存，防止丢帧
  uiContext: UIContext = this.getUIContext();
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;
  @State unAuthList: LocalDeviceInfo[] = [];

  transitionChange() {
    this.uiContext.animateTo({
      curve: Curve.Linear,
      duration: 80,
      delay: 80,
    }, () => {
      this.localDeviceOpacity = 0;
      this.deviceListItemOpacity = 1;
    })
  }
  /**
   * 设备列表的显示隐藏动效
   */
  setDeviceList() {
    log.showInfo(`setDeviceList with loop ${this.loop}|${this.deviceList.length}`);
    if (this.deviceList.length) {
      this.localDeviceItem = this.deviceList[0];
    }
    if (!this.loop) {
      log.showInfo(`update devicelist without copy length:${this.deviceListCopy.length}`);
      this.hookOpacityId = null;
      this.downHookOpacityId = null;
      this.deviceListCopy = [...this.deviceList];
      return;
    }
    if (this.deviceListCopy.length === 0) {
      this.loop = true;
      this.deviceListCopy = [...this.deviceList];
    } else if (this.deviceList.length > this.deviceListCopy.length) { //上线
      this.loop = false
      // 对钩动画
      this.setCurrentId(this.deviceListCopy, 'hookOpacityId'); //记录上次选中ID
      this.setCurrentId(this.deviceList, 'downHookOpacityId'); //当前ID
      this.deviceUpdate(this.deviceList, this.deviceListCopy);
      this.deviceListCopy = [...this.deviceList];
      if (this.hookOpacityId === this.downHookOpacityId) {
        this.hookOpacityId = null
        this.downHookOpacityId = null
      } else {
        this.hookOpacity = 1
        this.uiContext.animateTo({
          duration: 350, curve: Curve.Linear, onFinish: () => {
            this.hookOpacityId = null
            this.downHookOpacityId = null
          }
        }, () => {
          this.hookOpacity = 0
        })
      }
      this.listOpacity = 0
      this.listHeight = 0
      this.listScale = 0
      this.uiContext.animateTo({ duration: 150, delay: 200, curve: Curve.Linear }, () => {
        this.listOpacity = 1
      })
      this.uiContext.animateTo({
        duration: 350,
        tempo: 1.0,
        curve: Curve.Smooth,
        iterations: 1,
        playMode: PlayMode.Normal,
        onFinish: () => {
          this.onlineDeviceId = -1
          this.loop = true
          if (this.deviceList.length > this.deviceListCopy.length) {
            log.showInfo(' need do animate again')
            this.setDeviceList();
          }
        }
      }, () => {
        this.listScale = 1
        this.listHeight = this.getDeviceListHeightByScreen();
      })
    } else if (this.deviceList.length < this.deviceListCopy.length) { // 下线
      this.setCurrentId(this.deviceList, 'hookOpacityId'); // 记录当前选中ID实现对钩淡入
      this.setCurrentId(this.deviceListCopy, 'downHookOpacityId'); // 记录上次选中ID实现对钩淡出
      if (this.hookOpacityId === this.downHookOpacityId) {
        this.hookOpacityId = null
        this.downHookOpacityId = null
      } else {
        this.hookOpacity = 0
        this.uiContext.animateTo({
          duration: 350, curve: Curve.Linear, onFinish: () => {
            this.hookOpacityId = null
            this.downHookOpacityId = null
          }
        }, () => {
          this.hookOpacity = 1
        })
      }
      this.loop = false
      this.deviceUpdate(this.deviceListCopy, this.deviceList);
      this.listOpacity = 1
      this.listScale = 1
      this.listHeight = this.getDeviceListHeightByScreen()
      this.uiContext.animateTo({ duration: 150, curve: Curve.Linear }, () => {
        this.listOpacity = 0
        this.listScale = 0
      })
      this.uiContext.animateTo({
        duration: 350,
        tempo: 1.0,
        curve: Curve.Smooth,
        iterations: 1,
        playMode: PlayMode.Normal,
        onFinish: () => {
          this.deviceListCopy = [...this.deviceList];
          this.loop = true
          setTimeout(() => {
            this.onlineDeviceId = -1
          }, 100)
        }
      }, () => {
        this.listHeight = 0
      })
    } else {
      this.loop = true
      this.deviceListCopy = [...this.deviceList];
    }
  }

  setCurrentId(currentDeviceList: Array<LocalDeviceInfo>, hookId: string): void {
    for (let i = 0; i < currentDeviceList.length; i++) {
      if (currentDeviceList[i].deviceState == DeviceState.WORKING) {
        if (hookId == 'downHookOpacityId') {
          this.downHookOpacityId = currentDeviceList[i].deviceId
        } else {
          this.hookOpacityId = currentDeviceList[i].deviceId
        }
        break;
      }
    }
  }

  deviceUpdate(longArray: Array<LocalDeviceInfo>, short: Array<LocalDeviceInfo>) {
    if (this.deviceListCopy.length === 0 && this.deviceList.length === 1) {
      this.onlineDeviceId = longArray[0].deviceId
      return
    } else {
      for (let i = 0; i < longArray.length; i++) {
        let loop: boolean = false
        for (let j = 0; j < short.length; j++) {
          if (longArray[i].deviceId == short[j].deviceId) {
            loop = false
            break
          } else {
            loop = true
          }
        }
        if (loop) {
          this.onlineDeviceId = longArray[i].deviceId
          break
        }
      }
    }
  }

  isCheckBoxMode() {
    return this.selectMode === 'checkbox';
  }
  isCastWorkMode(item: LocalDeviceInfo) {
    return this.selectMode === 'ok' && item.deviceState === DeviceState.WORKING
  }

  isSmallScreenMode() {
    return this.selectMode === 'smallScreenDeviceList';
  }

  fontColor(item: LocalDeviceInfo, isIcon: boolean = false) {
    return item.deviceState === DeviceState.WORKING ? $r('app.color.media_control_text_primary_activated') :
      isIcon ? Color.Transparent : $r('app.color.media_control_text_primary');
  }

  fontSubColor(item: LocalDeviceInfo) {
    return item.deviceState === DeviceState.WORKING ?
      $r('app.color.media_control_text_primary_activated') :
      $r('app.color.media_control_text_secondary');
  }

  fontColorBrightness(item: LocalDeviceInfo) {
    if ((GlobalContext.getContext().config.colorMode as number) === 1) {
      // 浅色模式
      return this.colorModeViewData.getPrimaryFgOption(item.deviceState === DeviceState.WORKING);
    } else if (item.deviceState === DeviceState.WORKING) {
      // 深色选中
      return this.colorModeViewData.foregroundPrimaryOption;
    } else {
      // 深色非选中
      return this.colorModeViewData.foregroundSecondaryOption;
    }
  }

  // 检查是否是折叠屏
  isFordable(): boolean {
    try {
      this.ret = display.isFoldable();
      return this.ret
    } catch (exception) {
      log.error('Failed to check is foldable or not. Code: ' + JSON.stringify(exception));
      return false
    }
  }

  //获取可折叠设备的当前折叠状态
  getFoldStatus(): boolean {
    try {
      if (display.getFoldStatus() == 2) {
        this.isFolding = true
        return this.isFolding
      } else {
        this.isFolding = false
        return this.isFolding
      }
    } catch (exception) {
      log.error('Failed to obtain the fold status. Code: ' + JSON.stringify(exception));
      return false
    }
  }

  aboutToAppear() {
    AppStorage.setOrCreate('selectMode', this.selectMode);
    if (this.enableDc) {
      this.dcController?.setAppStorage('selectMode', this.selectMode);
    }
    try {
      this.dmInstance = distributedDeviceManager.createDeviceManager('com.ohos.sceneboard');
      // 监听非可信设备对端，PIN码操作回调
      this.dmInstance.on('replyResult', (data: dmReplyData) => {
        log.showInfo(`replyResult: ${data.param}`);
        let param: dmReplyDataParam = data.param ? JSON.parse(data.param) : {};
        if (param?.uiStateMsg === 3) {
          AppStorage.setOrCreate('showDmModal', false);
          if (this.enableDc) {
            this.dcController?.setAppStorage('showDmModal', false);
          }
          this.dmBindTarget = undefined;
        }
      })
    } catch (e) {
      let err: BusinessError = e as BusinessError;
      log.error(`createDeviceManager errCode: ${err.code}, errMessage: ${err.message}`);
    }
    this.textMaxFontScale = Constants.TEXT_MAX_FONT_SCALE;
  }

  aboutToDisappear(): void {
    if (!this.dmInstance) {
      return;
    }
    if (this.dmBindTarget) {
      log.showInfo(`unBindDmTarget ${this.dmBindTarget}`)
      this.unBindDmTarget(this.dmBindTarget);
      this.dmBindTarget = undefined;
    }
    try {
      this.dmInstance.off('replyResult');
      this.dmInstance = undefined;
    } catch (e) {
      let err: BusinessError = e as BusinessError;
      log.error(`createDeviceManager errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  @Styles pressedStyles() {
    .backgroundColor((this.isCheckBoxMode() || this.isSmallScreenMode()) ?
    Color.Transparent : $r('sys.color.interactive_click'))
  }

  isActive(item: LocalDeviceInfo) {
    let isHook = item.deviceId === this.downHookOpacityId || this.hookOpacityId === item.deviceId;
    let isCheckMode = this.isCheckBoxMode() || this.isSmallScreenMode();
    let isWorking = item.deviceState === DeviceState.WORKING && !this.deviceDisable &&
      (item.deviceId === this.curOutputDev.deviceId || item.deviceAddress === this.curOutputDev.deviceAddress)
    return isHook || (isCheckMode && isWorking);
  }

  isSymbolIcon(item: LocalDeviceInfo): boolean {
    return item.deviceSource === DeviceSource.LOCAL && (item.deviceType === audio.DeviceType.BLUETOOTH_A2DP ||
      item.deviceType === audio.DeviceType.BLUETOOTH_SCO);
  }

  private getDeviceListHeight(item: LocalDeviceInfo): number {
    return item.deviceId === this.onlineDeviceId ? this.listHeight : this.getDeviceListHeightByScreen();
  }

  private getDeviceListHeightByScreen(): number {
    return this.isSmallScreenMode() ? Constants.PANEL_LIST_ITEM_CONTENT_HEIGHT :
      MeasuringUtil.getHeight(16, Constants.PANEL_LIST_ITEM_CONTENT_HEIGHT,
      this.textMaxFontScale, this.getFontSizeScale());
  }

  private isConnecting(): boolean {
    const loadingDevice = this.deviceList.find((item: LocalDeviceInfo) => {
      return item.deviceState === DeviceState.CONNECTING;
    })
    return !!loadingDevice;
  }

  /**
   * 选择设备
   * @param item
   * @param isUnAuth
   */
  clickItem(item: LocalDeviceInfo, isUnAuth: boolean) {
    if (this.deviceDisable || !this.dsControl || this.isConnecting()) {
      return;
    }
    this.dmBindTarget = isUnAuth ? item.deviceId : this.dmBindTarget;
    log.showInfo(`click device: ${item.deviceName} | ${item.deviceType} | ${item.deviceState}`);
    if (item.deviceState === DeviceState.WORKING) {
      log.error( `this device is working, do not trigger it`);
      return;
    }
    this.dsControl?.selectDevice(item.deviceId, this.curSessionId, this.showDevType === ShowDevType.CALL);
  }

  /**
   * DM鉴权解绑
   * @param bindId
   */
  unBindDmTarget(bindId: string | number) {
    if (!this.dmInstance) {
      return;
    }
    try {
      this.dmInstance.unbindTarget(String(bindId));
    } catch (e) {
      let err: BusinessError = e as BusinessError;
      log.error(`unbindTarget errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  getResourceString(data: Resource) {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return ResUtils.getInnerString(data);
    } else {
      return ResourceVm.instance.getString(data);
    }
  }

  getFontSizeScale() {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return this.sysConfigData?.fontSizeScale || 1;
    } else {
      return ResourceVm.instance.fontScale;
    }
  }

  isRTL() {
    // 隔离主线程调用
    return ThreadUtil.isMainThread ? !!this.sysConfigData?.isRTL : ResourceVm.instance.isRTL;
  }

  /**
   * 分割线
   * @param prefix
   * @param index
   */
  @Builder DividerBuilder(prefix: string, index?: number) {
    Row() {
      Divider()
        .color($r('sys.color.comp_divider')) // 修改代码注意分割线颜色别改乱
        .opacity(0.5)
        .margin({
          left: this.isRTL() ? 0 : $r('sys.float.ohos_id_elements_margin_horizontal_l'),
          right: this.isRTL() ? $r('sys.float.ohos_id_elements_margin_horizontal_l') : 0
        })
    }
    .margin(this.isRTL() ?
      { left: !this.isSmallScreenMode() ?
      Constants.LIST_DIVIDER_MARGIN_RIGHT_CHECKBOX : Constants.LIST_DIVIDER_MARGIN_SMALL_SCREEN,
        right: (!this.isSmallScreenMode() ? Constants.LIST_DIVIDER_MARGIN_RIGHT_CHECKBOX :
        Constants.LIST_DIVIDER_MARGIN_SMALL_SCREEN) + Constants.COMMON_PICTURE_SIZE } :
      { left: (!this.isSmallScreenMode() ? Constants.LIST_DIVIDER_MARGIN_RIGHT_CHECKBOX :
      Constants.LIST_DIVIDER_MARGIN_SMALL_SCREEN) + Constants.COMMON_PICTURE_SIZE,
        right: !this.isSmallScreenMode() ?
        Constants.LIST_DIVIDER_MARGIN_RIGHT_CHECKBOX : Constants.LIST_DIVIDER_MARGIN_SMALL_SCREEN })
    .key(`${prefix}${index ?? ''}`)
    .zIndex(1)
  }

  getCallTitle(): string {
    return this.getResourceString($r('app.string.device_in_call'));
  }

  /**
   * 设备信息
   * @param item
   * @param index
   */
  @Builder DeviceBuilder(item: LocalDeviceInfo, index: number, type?: string) {
    Flex({alignItems: ItemAlign.Center}) {
      SymbolGlyph(item.deviceIcon)
        .fontSize(`${Constants.COMMON_PICTURE_SIZE}vp`)
        .fontColor([$r('app.color.media_control_icon_primary')])
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .margin({
          right: this.isRTL() ? 0 : $r('sys.float.ohos_id_elements_margin_horizontal_l'),
          left: this.isRTL() ? $r('sys.float.ohos_id_elements_margin_horizontal_l') : 0
        })
        .draggable(false)
        .flexGrow(0)
        .flexShrink(0)
        .flexBasis('auto')
        .renderingStrategy(item.fromCall && item.deviceType === audio.DeviceType.SPEAKER ?
          SymbolRenderingStrategy.SINGLE : SymbolRenderingStrategy.MULTIPLE_OPACITY)
        .key(`${this.prefix}_device_pic_No_${item.deviceId}.${index}`)
        .transition(type === 'localDevice' ? this.getTransition() : undefined)
        .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      Flex({direction: FlexDirection.Column, justifyContent: FlexAlign.Center}) {
        Text(item.deviceName)
          .fontWeight('sys.string.ohos_id_text_font_family_medium')
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .maxFontScale(this.isSmallScreenMode() ? 1 : this.textMaxFontScale)
          .fontColor(this.fontColor(item))
          .foregroundBrightness(this.fontColorBrightness(item))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .key(`${this.prefix}_device_name_No_${item.deviceId}.${index}`)
          .wordBreak(WordBreak.BREAK_ALL)
          .width('100%')
          .transition(type === 'localDevice' ? this.getTransition() : undefined)
          .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
        if (item.fromCall && this.showDevType !== ShowDevType.CALL) {
          Text(this.isRTL() ? `...${this.getCallTitle()}` : `${this.getCallTitle()}...`)
            .fontWeight(FontWeight.Regular)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .maxFontScale(this.isSmallScreenMode() ? 1 : this.textMaxFontScale)
            .fontColor(this.fontSubColor(item))
            .foregroundBrightness(item.deviceState === DeviceState.WORKING ?
              this.fontColorBrightness(item) : this.colorModeViewData.foregroundTertiaryGlossSubOption)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .key(`${this.prefix}_device_sub_name_No_${item.deviceId}.${index}`)
            .wordBreak(WordBreak.BREAK_ALL)
            .width('100%')
            .transition(type === 'localDevice' ? this.getTransition() : undefined)
            .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
        }
      }
    }
    .width('100%').height('100%')
    .transition(type === 'localDevice' ? this.getTransition(1) : undefined)
  }

  /**
   * 设备行
   * @param item
   * @param index
   */
  @Builder DeviceItemBuilder(item: LocalDeviceInfo, index: number, type?: string) {
    Flex({justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center}) {
      this.DeviceBuilder(item, index, type)
      Row() {
        if (this.isActive(item)) {
          SymbolGlyph($r(AVCastPickerDeviceIconName.SELECTED_ICON_SYMBOL))
            .fontSize(`${Constants.COMMON_PICTURE_SIZE}vp`)
            .fontColor([this.fontColor(item, true)])
            .draggable(false)
            .opacity(this.hookOpacityId == item.deviceId ? this.hookOpacity : 1)
            .renderingStrategy(SymbolRenderingStrategy.SINGLE)
            .transition(type === 'localDevice' ? this.getTransition() : undefined)
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        } else {
          LoadingProgress()
            .width(Constants.COMMON_PICTURE_SIZE)
            .height(Constants.COMMON_PICTURE_SIZE)
            .color(this.isSysColor ? $r('sys.color.icon_secondary') : $r('app.color.media_control_Loading_progress'))
            .key(`${this.prefix}_device_processing_icon_No_${item.deviceId}.${index}`)
            .visibility(item.deviceState === DeviceState.CONNECTING ? Visibility.Visible : Visibility.None)
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }
      }
      .accessibilityLevel('yes')
      .width(this.isSmallScreenMode() ? 24 : 48)
      .height(this.isPC ? Constants.PC_DEVICE_ITEM_HEIGHT : (this.isSmallScreenMode() ? 24 : 48))
      .flexGrow(0)
      .flexShrink(0)
      .flexBasis('auto')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.End)
    }
    .accessibilityGroup(true)
    .height(this.isPC ? Constants.PC_DEVICE_ITEM_HEIGHT : this.getDeviceListHeightByScreen())
    .padding({
      left: this.isPC ? Constants.PC_DEVICE_CARD_CONTENT_PADDING :
        (this.isSmallScreenMode() ? 12 : Constants.LIST_DIVIDER_MARGIN_RIGHT_CHECKBOX),
      right: this.isPC ? Constants.PC_DEVICE_CARD_CONTENT_PADDING :
        (this.isSmallScreenMode() ? 12 : Constants.LIST_DIVIDER_MARGIN_RIGHT_CHECKBOX)
    })
    .borderRadius(Constants.DEVICE_ICON_HEIGHT)
    .backgroundColor(this.curIndex == index ? $r('sys.color.interactive_hover') : Constants.TRANSLUCENT_COLOR)
    .stateStyles({pressed: this.pressedStyles})
    .onHover((isHover?: boolean) => {
      this.curIndex = isHover ? index : -1;
    })
    .transition(type === 'localDevice' ? this.getTransition() : undefined)
  }

  /**
   * 可信设备列表
   */
  @Builder DeviceListBuilder() {
    ForEach(this.deviceListCopy, (item: LocalDeviceInfo, index) => {
      Stack({alignContent: Alignment.Top}) {
        this.DeviceItemBuilder(item, index)
        if (index !== 0) {
          this.DividerBuilder(`${this.prefix}_device_divider_No_${item.deviceId}.`, index)
        }
      }
      .accessibilityGroup(true)
      .accessibilitySelected(this.isActive(item))
      .alignContent(Alignment.Top)
      .opacity(item.deviceId == this.onlineDeviceId ? this.listOpacity : 1)
      .height(this.isPC ? Constants.PC_DEVICE_ITEM_HEIGHT : this.getDeviceListHeight(item))
      .margin({ bottom: this.isPC ? Constants.PC_DEVICE_ITEM_GUTTER : 0 })
      .scale({
        z: item.deviceId == this.onlineDeviceId ? this.listScale : 1, x: 1, y: 1
      })
      .width('100%')
      .onClick(() => {
        this.clickItem(item, false);
      })
      .key(`${this.prefix}_device_item_No_${item.deviceId}.${index}`)
      .id(`trustDeviceItem.${index}`)
    })
  }

  /**
   * 非可信设备标题（更多设备）
   */
  @Builder UnAuthTitleBuilder() {
    Row() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text($r('app.string.unAuthDevice'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(this.isSmallScreenMode() ? 1 : this.textMaxFontScale)
          .fontColor($r('app.color.media_control_text_secondary'))
          .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossSubOption)
          .fontWeight(FontWeight.Medium)
          .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
          .maxLines(1)
          .wordBreak(WordBreak.HYPHENATION)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Image(this.isExpand ? $r('sys.media.ohos_ic_public_arrow_up') :
        $r('sys.media.ohos_ic_public_arrow_down'))
          .fillColor($r('app.color.media_control_icon_primary'))
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .height(12)
          .width(24)
          .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      }
      .height(this.isSmallScreenMode() ? 40 :
        MeasuringUtil.getHeight(14, 40, this.textMaxFontScale, this.getFontSizeScale()))
      .width('100%')
      .padding(this.isSmallScreenMode() ? { top: 4, left: 12, right: 12 } : { top: 7, left: 24, right: 24 })
    }
    .width('100%')
    .padding({
      top: 7,
      bottom: this.unAuthList.length > 0 && this.isExpand ? 0 : 8
    })
    .accessibilityGroup(true)
    .accessibilityText(ResUtils.getInnerString($r('app.string.access_expand_more_devices')))
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .onClick(() => {
      this.hideDeviceScroll = true;
      this.uiContext.animateTo({
        curve: Curves.interpolatingSpring(0, 1, 228, 25),
        onFinish: () => {
          this.hideDeviceScroll = false;
          if (this.isSmallScreenMode() && this.isExpand) {
            let yOffset: number = this.scroller?.currentOffset()?.yOffset || 0;
            this.scroller?.scrollTo({ xOffset: 0, yOffset: yOffset + Constants.PANEL_LIST_ITEM_CONTENT_HEIGHT,
              animation: { duration: 1000, curve: Curve.Linear } })
          }
        }
      }, () => {
        this.isExpand = !this.isExpand;
      })
    })
    .id('mediaMoreDevice')
  }

  /**
   * 非可信设备列表
   */
  @Builder UnAuthListBuilder() {
    this.DividerBuilder(`${this.prefix}_unauth_title`)
    this.UnAuthTitleBuilder()

    Column() {
      ForEach(this.unAuthList, (item: LocalDeviceInfo, index) => {
        Stack() {
          this.DeviceItemBuilder(item, index)
          if (index !== 0) {
            this.DividerBuilder(`${this.prefix}_unauth_device_divider_No_${item.deviceId}.`, index)
          }
        }
        .alignContent(Alignment.Top)
        .opacity(item.deviceId == this.onlineDeviceId ? this.listOpacity : 1)
        .height(this.isPC ? Constants.PC_DEVICE_ITEM_HEIGHT : this.getDeviceListHeight(item))
        .margin({ bottom: this.isPC ? Constants.PC_DEVICE_ITEM_GUTTER : 0 })
        .scale({
          z: item.deviceId == this.onlineDeviceId ? this.listScale : 1, x: 1, y: 1
        })
        .width('100%')
        .onClick(() => {
          this.clickItem(item, true);
        })
        .key(`${this.prefix}_unauth_device_item_No_${item.deviceId}.${index}`)
        .id(`deviceNotTrust.${index}`)
      })
    }
    .visibility(this.isExpand ? Visibility.Visible : Visibility.None)
    .width('100%')
    .id('unAuthList')
  }

  @Builder ListBuilder() {
    Column() {
      this.DeviceListBuilder()
      if (this.unAuthList.length > 0) {
        this.UnAuthListBuilder()
      }
    }
    .padding({ top: 4, bottom: 4})
    .backgroundBlurStyle(BlurStyle.Regular, { policy: 1 })
    .backdropBlur(this.isPC ? 25 : 0)
    .borderRadius(this.isPC ? Constants.TABLET_WINDOW_DEFAULT_RADIUS : (this.isSmallScreenMode() ?
      Constants.SMALL_SCREEN_DEVICE_LIST_LEFTRIGHTPADDING : Constants.SECOND_PANEL_BORDER_RADIUS))
    .opacity(this.isSmallScreenMode() ? (this.mediaTransitionDone ? this.deviceListItemOpacity : 0) : 1)
  }

  getTransition(scale: number = 0.7) {
    if (!this.isSmallScreenMode()) {
      return undefined;
    }
    return this.mediaTransitionDone ? undefined : TransitionEffect.OPACITY
      .animation({ duration: 180, curve: Curves.interpolatingSpring(0, 1, 228, 25)})
      .combine(TransitionEffect.scale({ x: scale, y: scale, centerX: 0, centerY: 0}))
  }

  build() {

    if (this.isSmallScreenMode()) {
      Stack({ alignContent: Alignment.TopStart }) {
        Column()
          .width('100%')
          .height(Constants.SMALL_SCREEN_DEVICE_LIST_MAX_HEIGHT)
          .backgroundColor($r('app.color.media_control_card_bgc'))
          .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
          .borderRadius(Constants.TABLET_WINDOW_DEFAULT_RADIUS)
          .zIndex(0)
          .id(`smallScreenDeviceListBgEnd`)
          .geometryTransition('smallScreenDeviceListBg')

        Column() {
          Scroll(this.scroller) {
            Stack({ alignContent: Alignment.TopStart }) {
              if (this.localDeviceItem) {
                Column() {
                  this.DeviceItemBuilder(this.localDeviceItem, 0, 'localDevice')
                }
                .margin({top: 4})
                .width('100%')
                .height(Constants.PANEL_LIST_ITEM_CONTENT_HEIGHT)
                .align(Alignment.TopStart)
                .transition(this.getTransition(1))
                .opacity(this.mediaTransitionDone ? this.localDeviceOpacity : 1)
              }
              this.ListBuilder()
            }
          }
          .width('100%')
          .height(Constants.SMALL_SCREEN_DEVICE_LIST_MAX_HEIGHT)
          .align(Alignment.TopStart)
          .borderRadius(Constants.TABLET_WINDOW_DEFAULT_RADIUS)
          .scrollBar(this.mediaTransitionDone ? BarState.Auto : BarState.Off)
        }
        .width('100%')
        .height(Constants.SMALL_SCREEN_DEVICE_LIST_MAX_HEIGHT)
        .id('LocalDeviceEnd')
        .geometryTransition('LocalDevice')
      }
      .id('smallScreenDeviceListCard')
   } else {
     this.ListBuilder()
   }
  }
}