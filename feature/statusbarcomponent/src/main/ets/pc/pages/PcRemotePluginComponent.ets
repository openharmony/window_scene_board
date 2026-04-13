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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  HiDfxEventUtil,
  PluginComponentInfo,
  PluginContentEvent,
  PluginIconType,
  PluginUpdateEvent,
  PluginSlot
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import PCM from '@ohos.pluginComponent';
import { PluginVM } from '@ohos/plugincomponent/src/main/ets/vm/PluginVM';
import { PluginProperty } from '../viewdata/PluginProperty';
import { PluginStyle } from '../style/PluginStyle';
import { AnimProperty } from '../manager/AnimManager';
import StatusBarManager from '../manager/StatusBarManager';
import WifiIconPC from '@ohos/wificomponent/src/main/ets/default/pages/wifiIconPC';
import PcSearchIconPage from './PcSearchIconPage';
import { PcStatusBarDragMgr } from '../manager/PcStatusBarDragMgr';
import { Constants } from '../common/Constants';
import { StatusBarTint } from '../../common/StatusBarTint';
import { PluginDisplayStyle } from '../common/PluginConstants';
import { PluginStyleUtil } from '../common/PluginStyleUtil';

const TAG = 'RemotePluginComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);


/**
 * plugin组件数据键值，内容颜色
 */
const PLUGIN_KEY_CONTENT_COLOR = 'contentColor';

/**
 * plugin组件数据键值，内容宽度
 */
const PLUGIN_KEY_CONTENT_WIDTH = 'contentWidth';

/**
 * plugin组件数据键值，内容高度
 */
const PLUGIN_KEY_CONTENT_HEIGHT = 'contentHeight';

/**
 * 自适应宽度，最大值
 */
const DEFAULT_MAX_WIDTH = 300;

/**
 * Symbol化图标，大小定制化处理
 */
const SYMBOL_ICON_SIZE_MAP: Map<string, number> = new Map([
  [PluginSlot.SLOT_STATUS_SMART_SCREENSHOT, 20],
  [PluginSlot.SLOT_STATUS_QUICK_NOTE, 18],
  [PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT, 20],
  [PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD, 20],
  [PluginSlot.SLOT_STATUS_SCREEN_RECORDER, 22]
]);

/**
 * 外部接入PluginComponent组件
 *
 * @since 2022-10-18
 */
@Component
export struct PcRemotePluginComponent {
  @ObjectLink property: PluginProperty;
  @ObjectLink pluginStyle: PluginStyle;
  @ObjectLink animProperty: AnimProperty;

  private mAnimation: AnimateParam | null = null;
  /**
   * 数据处理
   */
  pluginVM: PluginVM | null = null;
  /**
   * 图标宽度
   */
  iconWidth: Length = 0;
  /**
   * 图标高度
   */
  iconHeight: Length = 0;
  /**
   * 图标内容颜色
   */
  @Consume @Watch('refreshPluginData') contentColor: string;

  @State isDark: boolean = false;
  /**
   * plugin模板名
   */
  @State pluginTemplateName: string = '';
  /**
   * plugin提供方包名
   */
  @State pluginBundleName: string = '';
  /**
   * plugin图标padding，用于刷新UI
   * 在0和0.1之间切换
   */
  @State pluginPadding: number = 0;
  @State iconRes: Resource | undefined = undefined;
  /**
   * 默认传递宽度
   */
  private defaultIconWidth: number = 0;
  /**
   * 默认传递高度
   */
  private defaultIconHeight: number = 0;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 图标本地化回调函数
   */
  private getIcon: Function = () => {
  };
  private getActiveWifiIcon: Function = () => {
  };

  aboutToAppear(): void {
    log.showInfo('aboutToAppear slot:' + this.property.getSlot());
    // 转换宽高，用于计算
    this.defaultIconWidth = ResUtils.getNumberFromLength(this.iconWidth);
    this.defaultIconHeight = ResUtils.getNumberFromLength(this.iconHeight);
    // 初始化数据
    this.refreshPluginData();
    // 图标内容颜色变更事件
    this.eventMgr.on(PluginContentEvent, this.onPluginContentEvent, this.property.getSlot())// plugin数据更新事件
      .on(PluginUpdateEvent, this.onPluginUpdateEvent)// 监听远程push事件
      .addOff(this.pluginVM?.registerOnRemotePushListener(this.onRemotePushListener) ?? (() => {
      }));
    this.getIcon = StatusBarManager.getInstance().getRemotePluginIconCallback?.();
    this.getActiveWifiIcon = StatusBarManager.getInstance().getActiveWifiIcon?.();
    this.iconRes = this.getIcon(this.property.getSlot())?.(this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear slot: ' + this.property.getSlot() + 'statusBarType: ' +
    PluginDisplayStyle[PluginStyleUtil.getCurStatusBarType()]);
    this.eventMgr.offAll();
  }

  buildLog(): boolean {
    log.showInfo('slot: ' + this.getPluginInfo()?.getSlot() +
      ',pluginTemplateName: ' + this.pluginTemplateName + ',bundleName: ' + this.pluginBundleName);
    return true;
  }

  getPluginInfo(): PluginComponentInfo {
    return this.property.pluginInfo as PluginComponentInfo;
  }

  build() {
    if (this.property.getSlot() === PluginSlot.SLOT_STATUS_WIFI_PANEL) {
      WifiIconPC({
        getIcon: this.getIcon,
        getActiveWifiIcon: this.getActiveWifiIcon,
        animProperty: this.animProperty,
        iconWidth: this.pluginStyle?.getIconWidth(),
        iconHeight: this.pluginStyle?.iconHeight
      })
    } else if (SYMBOL_ICON_SIZE_MAP.has(this.property.getSlot())) {
      this.buildSymbolIcon(SYMBOL_ICON_SIZE_MAP.get(this.property.getSlot()) ?? 0);
    } else if (this.property.getSlot() === PluginSlot.SLOT_STATUS_SEARCH) {
      PcSearchIconPage({property: this.property})
    } else if (this.iconRes) {
      Image(this.iconRes)
        .padding(this.pluginPadding)
        .size({ width: this.getIconWidth(), height: ResUtils.getNumberFromLength(this.iconHeight) })
        .width(this.pluginStyle?.getIconWidth())
        .height(this.pluginStyle?.iconHeight)
        .borderRadius(this.pluginStyle?.iconContainerRadius)// 动效期间不切割
        .clip(false)
        .scale({ x: this.animProperty?.scaleX, y: this.animProperty?.scaleY })
        .animation(this.mAnimation)
        .draggable(false)
        .renderGroup(true)
        .syncLoad(true)
        .interpolation(ImageInterpolation.High)
        .id(`RemotePluginComponent_PluginComponent_${this.property.getSlot()}`)
    } else {
      // plugin组件可见性
      if (!CommonUtils.isEmpty(this.pluginTemplateName) && this.buildLog()) {
        PluginComponent({
          template: {
            source: this.pluginTemplateName,
            bundleName: this.pluginBundleName
          },
          data: this.getPluginData()
        })
          .padding(this.pluginPadding)
          .size({ width: this.getIconWidth(), height: ResUtils.getNumberFromLength(this.iconHeight) })
          .width(this.pluginStyle?.getIconWidth())
          .height(this.pluginStyle?.iconHeight)
          .borderRadius(this.pluginStyle?.iconContainerRadius)// 动效期间不切割
          .clip(false)
          .scale({ x: this.animProperty?.scaleX, y: this.animProperty?.scaleY })
          .animation(this.mAnimation)
          .enabled(this.pluginStyle?.iconEnable || this.property?.isEnabled())
          .onError((info) => {
            log.showError('onError' + info.errcode + ':' + info.msg);
            let failMsg = info.errcode + ':' + info.msg;
            let bundleName = this.pluginBundleName + '_' + this.property.getSlot();
            HiDfxEventUtil.reportPluginFailed(bundleName, 0, failMsg)
          })
          .onComplete(() => {
            log.info('PluginComponent onComplete');
            PcStatusBarDragMgr.getInstance().pluginComponentOnComplete(this.property.getSlot());
          })
          .renderGroup(true)
          .id(`RemotePluginComponent_PluginComponent_${this.property.getSlot()}`)
      }
    }
  }

  @Builder
  buildSymbolIcon(iconSize: number) {
    Row() {
      Text() {
        SymbolSpan(this.iconRes)
          .fontSize(`${vp2px(iconSize)}px`)
          .fontColor([this.contentColor])
          .fontWeight(FontWeight.Bold)
      }
      .borderRadius(this.pluginStyle?.iconContainerRadius) // 动效期间不切割
      .clip(false)
      .opacity(Constants.SYMBOL_ICON_OPACITY)
      .scale({ x: this.animProperty?.scaleX, y: this.animProperty?.scaleY })
      .id(`RemotePluginComponent_PluginComponent_${this.property.getSlot()}`)
      .animation(this.mAnimation)
      .size({ width: this.getIconWidth(), height: ResUtils.getNumberFromLength(this.iconHeight) })
      .width(this.pluginStyle?.getIconWidth())
      .height(this.pluginStyle?.iconHeight)
      .textAlign(TextAlign.Center)
      .textShadow(this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE ? Constants.SYMBOL_ICON_SHADOW : [])
    }
  }

  /**
   * 刷新plugin相关变量
   */
  private refreshPluginData(): void {
    this.pluginBundleName = this.getPluginInfo()?.pluginParseInfo?.bundleName ?? '';
    this.isDark = (this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE);
    log.showInfo(`contentColor:${this.contentColor} isDark color:${this.isDark}`);
    if (this.contentColor === StatusBarTint.CONTENT_COLOR_BLACK) {
      this.iconRes = this.getIcon(this.property.getSlot())?.(this.isDark);
      this.pluginTemplateName = this.getPluginInfo()?.pluginParseInfo?.pluginTemplateName ?? '';
    } else {
      this.iconRes = this.getIcon(this.property.getSlot())?.(this.isDark);
      this.pluginTemplateName = this.getPluginInfo()?.pluginParseInfo?.pluginBackTemplateName ??
        (this.getPluginInfo()?.pluginParseInfo?.pluginTemplateName ?? '');
    }
    log.showDebug(`getPluginTemplateSource template is ${this.pluginTemplateName} ${JSON.stringify(this.getPluginInfo()?.pluginParseInfo)}`);
  }

  /**
   * 更新plugin数据事件回调
   *
   * @param event 事件
   */
  private onPluginUpdateEvent = (event: PluginUpdateEvent): void => {
    // 更新数据
    if (this.getPluginInfo() && event.newInfo?.equals(this.getPluginInfo())) {
      event.newInfo.pluginParseInfo.contentColor = StatusBarTint.CONTENT_COLOR_BLACK;
      this.property.pluginInfo = event.newInfo as PluginComponentInfo;
      // 刷新变量
      this.refreshPluginData();
      log.showInfo(`onPluginUpdateEvent: ${this.contentColor} ${PluginDisplayStyle[PluginStyleUtil
        .getCurStatusBarType()]}`);
    }
  }

  /**
   * 远程push事件回调
   *
   * @param info 事件数据
   */
  private onRemotePushListener = (info: PluginComponentInfo): void => {
    // 自适应宽度，则使用请求宽度
    if (this.isWidthAutoType() && info.requestWidth != this.pluginStyle.iconRequestWidth) {
      this.pluginStyle.iconRequestWidth = info.requestWidth > DEFAULT_MAX_WIDTH ?
        DEFAULT_MAX_WIDTH : ResUtils.getNumberFromLength(info.requestWidth) as number;
    }
    // 对比plugin data是否有变化
    this.checkUpdatePluginData(info.pluginData);
  }
  /**
   * 图标内容颜色事件
   *
   * @param event 事件
   */
  private onPluginContentEvent = (event: PluginContentEvent): void => {
    // 对象匹配，slot标示匹配
    if (!event.pluginSlotMap) {
      log.showDebug('onPluginContentEvent pluginSlotMap is null');
      return;
    }
    let newContentColor: string | undefined = event.pluginSlotMap.get(this.property.getSlot());
    if (!newContentColor) {
      log.showDebug('onPluginContentEvent newContentColor is null');
      return;
    }
    log.showDebug('onPluginContentEvent this root:' + this.property.rootParentId + 'slot: ' +
    this.property.getSlot() + ', color:' + newContentColor);
    if (this.property.rootParentId !== event.rootParentId) {
      log.showInfo(`onPluginContentEvent this root ${this.property.rootParentId}
        contentColor: ${this.contentColor} statusBarType: ${PluginDisplayStyle[PluginStyleUtil
        .getCurStatusBarType()]}`);
      return;
    }
    if (!this.getPluginInfo()?.pluginParseInfo) {
      log.showInfo('onPluginContentEvent pluginInfo not exist');
      return;
    }
    log.showInfo(`onPluginContentEvent: ${this.contentColor} ${PluginDisplayStyle[PluginStyleUtil
      .getCurStatusBarType()]}`);
  }

  /**
   * plugin组件传递参数
   * 已有参数基础上，增加systemui业务属性
   */
  private getPluginData(): PCM.KVObject {
    let data = this.getPluginInfo()?.pluginData;
    if (!data) {
      data = {};
    }
    data[PLUGIN_KEY_CONTENT_COLOR] = this.contentColor;
    data[PLUGIN_KEY_CONTENT_WIDTH] = this.getIconWidth();
    data[PLUGIN_KEY_CONTENT_HEIGHT] = this.defaultIconHeight;
    return data;
  }

  /**
   * 检测plugin data是否有变化
   *
   * @param newData 最新data
   */
  private checkUpdatePluginData(newData: PCM.KVObject): void {
    if (!newData || !this.getPluginInfo()) {
      return;
    }
    let oldData = this.getPluginInfo()?.pluginData;
    if (!oldData) {
      this.getPluginInfo().pluginData = newData;
      this.refreshUI();
      return;
    }
    // 对比参数是否变化
    if (this.getPluginInfo()) {
      for (let key = 0; key < newData.length; ++key) {
        if (oldData[key] != newData[key]) {
          this.getPluginInfo().pluginData = newData;
          this.refreshUI();
          break;
        }
      }
    }
  }

  /**
   * plugin组件宽度
   *
   * @return 宽度
   */
  private getIconWidth(): number {
    // 非自适应宽度，固定宽度
    if (!this.isWidthAutoType()) {
      return ResUtils.getNumberFromLength(this.defaultIconWidth) as number;
    }
    // 自适应宽度，采用远程应用请求宽度
    return ResUtils.getNumberFromLength(this.pluginStyle.iconRequestWidth) as number;
  }

  /**
   * 是否为宽度自适应
   *
   * @return 是否宽度自适应
   */
  private isWidthAutoType(): boolean {
    let iconType = this.getPluginInfo()?.pluginParseInfo?.pluginIconType;
    return iconType == PluginIconType.TYPE_AUTO_ICON;
  }

  /**
   * 刷新UI
   */
  private refreshUI(): void {
    if (this.pluginPadding == 0) {
      this.pluginPadding = 0.1;
    } else {
      this.pluginPadding = 0;
    }
  }
}