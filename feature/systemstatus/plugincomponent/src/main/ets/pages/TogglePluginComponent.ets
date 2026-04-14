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

import {
  LogDomain,
  LogHelper,
  CommonUtils,
} from '@ohos/basicutils';
import {
  PluginSlot,
  PluginComponentInfo,
  WindowEvent,
  HiDfxEventUtil,
  EventManager,
  EvtBus,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene'
import { HoverConstants } from '@ohos/commonconstants';
import { ToggleStyle } from '@ohos/systemuicommon';
import { BaseController, CommonData } from '@ohos/controlcentercommon/Index';
import PCM from '@ohos.pluginComponent';
import { PluginToggleController } from '../controller/PluginToggleController';

const TAG = 'TogglePluginComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const COMPONENT_ID: string = TAG + '_PluginComponent_';
const COMPONENT_ID_TEXT: string = TAG + '_TEXT_';
const COMPONENT_ID_ARROW: string = TAG + '_Image_Arrow_';

/**
 * plugin点击监听
 */
const PLUGIN_KEY_CLICK = 'isClick';

/**
 * plugin hover事件监听
 */
const PLUGIN_KEY_HOVER = 'isHover';

/**
 * plugin长按点击监听
 */
const PLUGIN_KEY_LONG_CLICK = 'isLongClick';

/**
 * plugin开关编辑拖动监听
 */
const PLUGIN_KEY_DRAGMODE = 'isDragging';

/**
 * plugin开关图标Hover监听
 */
const PLUGIN_KEY_ICONHOVER = 'isIconHover';

/**
 * plugin开关文字Hover监听
 */
const PLUGIN_KEY_LABELHOVER = 'isLabelHover';

/**
 * plugin开关高度
 */
const PLUGIN_KEY_CELLHEIGHT = 'cellHeight';

/**
 * plugin开关宽度
 */
const PLUGIN_KEY_CELLWIDTH = 'cellWidth';

/**
 * plugin开关图标背景宽度
 */
const PLUGIN_KEY_CIRCLEWIDTH = 'circleWidth';

/**
 * plugin开关图标背景高度
 */
const PLUGIN_KEY_CIRCLEHEIGHT = 'circleHeight';

/**
 * plugin开关图标宽度
 */
const PLUGIN_KEY_ICONWIDTH = 'iconWidth';

/**
 * plugin开关图标高度
 */
const PLUGIN_KEY_ICONHEIGHT = 'iconHeight';

/**
 * plugin开关拖动图标背景宽度
 */
const PLUGIN_KEY_DRAGCIRCLEWIDTH = 'dragCircleWidth';

/**
 * plugin开关拖动图标背景高度
 */
const PLUGIN_KEY_DRAGCIRCLEHEIGHT = 'dragCircleHeight';

/**
 * plugin开关拖动图标宽度
 */
const PLUGIN_KEY_DRAGICONWIDTH = 'dragIconWidth';

/**
 * plugin开关拖动图标高度
 */
const PLUGIN_KEY_DRAGICONHEIGHT = 'dragIconHeight';

/**
 * plugin开关图标背景关闭颜色
 */
const PLUGIN_KEY_ICONOFFBG = 'iconOffBG';

/**
 * plugin开关图标背景开启颜色
 */
const PLUGIN_KEY_ICONONBG = 'iconOnBG';

/**
 * plugin开关图标开启颜色
 */
const PLUGIN_KEY_ICONONCOLOR = 'iconOnColor';

/**
 * plugin开关图标关闭颜色
 */
const PLUGIN_KEY_ICONOFFCOLOR = 'iconOffColor';

/**
 * plugin开关图标上间距
 */
const PLUGIN_KEY_ICONMARGINTOP = 'iconMarginTop';

/**
 * plugin开关图标下间距
 */
const PLUGIN_KEY_ICONMARGINBOTTOM = 'iconMarginBottom';

/**
 * plugin开关文字大小
 */
const PLUGIN_KEY_TITLESIZE = 'titleSize';

/**
 * plugin开关文字颜色
 */
const PLUGIN_KEY_TITLECOLOR = 'titleColor';

/**
 * plugin开关文字Hover背景宽度
 */
const PLUGIN_KEY_TEXTHOVERWIDTH = 'textHoverWidth';

/**
 * plugin开关文字Hover背景高度
 */
const PLUGIN_KEY_TEXTHOVERHEIGHT = 'textHoverHeight';

/**
 * plugin开关文字Hover背景圆角
 */
const PLUGIN_KEY_TEXTHOVERRADIUS = 'textHoverRadius';

/**
 * plugin开关文字Hover背景颜色
 */
const PLUGIN_KEY_HOVERCOLOR = 'hoverColor';

/**
 * plugin开关文字Hover背景透明色
 */
const PLUGIN_KEY_TRANSPARENTCOLOR = 'transparentColor';

// copy from ./unlock/ScreenLockMediator.ets::ScreenLockStatus
enum ScreenLockStatus {
  LOCKING = 1,
  UNLOCK = 2
}

const NOTIFY_LOCK_STATUS_DELAY: number = 1500;

/**
 * 外部接入PluginComponent组件
 *
 * @since 2022-10-18
 */
@Component
export struct TogglePluginComponent {
  /**
   * plugin唯一标识
   */
  slot: string = '';
  /**
   * plugin组件数据
   */
  pluginInfo: PluginComponentInfo = new PluginComponentInfo();
  /**
   * plugin控制类
   */
  controller: BaseController<CommonData> | null = null;
  @State isClick: boolean = false;
  @State isLongClick: boolean = false;
  @State isDragging: boolean = false;
  @State isEditMode: boolean = false;
  @State isIconHover: boolean = false;
  @State isLabelHover: boolean = false;
  private isHover: boolean = false;
  @State cellHeight: number = ToggleStyle.getStyle().cellHeight;
  @State cellWidth: number = ToggleStyle.getStyle().cellWidth;
  @State circleWidth: number = ToggleStyle.getStyle().circleWidth;
  @State circleHeight: number = ToggleStyle.getStyle().circleHeight;
  @State iconWidth: number = ToggleStyle.getStyle().iconWidth;
  @State iconHeight: number = ToggleStyle.getStyle().iconHeight;
  @State dragCircleWidth: number = ToggleStyle.getStyle().dragCircleWidth;
  @State dragCircleHeight: number = ToggleStyle.getStyle().dragCircleHeight;
  @State dragIconWidth: number = ToggleStyle.getStyle().dragIconWidth;
  @State dragIconHeight: number = ToggleStyle.getStyle().dragIconHeight;
  @State iconOffBG: string = ToggleStyle.getStyle().iconOffBG1;
  @State iconOnBG: string = ToggleStyle.getStyle().iconOnBG1;
  @State iconOnColor: string = ToggleStyle.getStyle().iconOnColor;
  @State iconOffColor: string = ToggleStyle.getStyle().iconOffColor1;
  @State iconMarginTop: number = ToggleStyle.getStyle().iconMarginTop;
  @State iconMarginBottom: number = ToggleStyle.getStyle().iconMarginBottom;
  @State titleSize: number = ToggleStyle.getStyle().titleSize;
  @State titleColor: string = ToggleStyle.getStyle().titleColor1;
  @State textHoverWidth: number = ToggleStyle.getStyle().textHoverWidth;
  @State textHoverHeight: number = ToggleStyle.getStyle().textHoverHeight;
  @State textHoverRadius: number = ToggleStyle.getStyle().textHoverRadius;
  @State hoverColor: string = ToggleStyle.getStyle().hoverColor;
  @State transparentColor: string = ToggleStyle.getStyle().transparentColor;
  @State subPanelSize: number = ToggleStyle.getStyle().subPanelSize;
  @State marginLeft: number = ToggleStyle.getStyle().marginLeft;
  @State marginRight: number = ToggleStyle.getStyle().marginRight;
  @State textMargin: number = ToggleStyle.getStyle().textMargin;
  @State topIconPadding: number = ToggleStyle.getStyle().topIconPadding;
  @State name: string = '';

  // newStyle
  @State buttonDiameter: number = ToggleStyle.getStyle().buttonDiameter;
  @State newIconPadding: number = ToggleStyle.getStyle().newIconPadding;
  @State pluginComponentPadding: number = ToggleStyle.getStyle().pluginComponentPadding;
  @State pluginComponentRightPadding: number = ToggleStyle.getStyle().pluginComponentRightPadding;
  @State iconDiameter: number = ToggleStyle.getStyle().iconDiameter;
  @State buttonLabelSpace: number = ToggleStyle.getStyle().buttonLabelSpace;
  @State newIconOffBGStr: string = ToggleStyle.getStyle().newIconOffBGStr;
  @State newIconOnBGStr: string = ToggleStyle.getStyle().newIconOnBGStr;
  @State newIconOnColorStr: string = ToggleStyle.getStyle().newIconOnColorStr;
  @State newIconOffColorStr: string = ToggleStyle.getStyle().newIconOffColorStr;
  @State labelFontColorStr: string = ToggleStyle.getStyle().labelFontColorStr;
  @State labelFontSize: number = ToggleStyle.getStyle().labelFontSize;
  @State iconOnBgBrightness: number = ToggleStyle.getStyle().iconOnBgBrightness;
  @State iconOffBgBrightness: number = ToggleStyle.getStyle().iconOffBgBrightness;
  @State iconOffBrightness: number = 1; // 支持之后再动态修改
  @State iconOnBrightness: number = 1; // 支持之后再动态修改
  @State labelLineHeight: number = ToggleStyle.getStyle().labelLineHeight;
  @State iconBGShadowColor: string = ToggleStyle.getStyle().toggleIconShadowColor;
  @State iconBGShadowRadius: number = ToggleStyle.getStyle().toggleIconShadowRadius;
  @State iconBGShadowOffsetY: number = ToggleStyle.getStyle().toggleIconShadowOffsetY;
  @State rateOnValue: number = ToggleStyle.getStyle().rateOnValue;
  @State rateOffValue: number = ToggleStyle.getStyle().rateOffValue;
  @State lightOnValue: number = ToggleStyle.getStyle().lightOnValue;
  @State lightOffValue: number = ToggleStyle.getStyle().lightOffValue;
  @StorageLink('lockStatus') @Watch('onLockStatusChanged') lockStatus: number = 0;

  @StorageLink('isNewStyle') isNewStyle: boolean = false;
  isPC: boolean = DeviceHelper.isPC();
  @State animateScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  private eventMgr: EventManager | undefined = undefined;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear slot: ' + this.slot);
    if (this.pluginInfo.pluginParseInfo.labelResName) {
      ResUtils.getOutStringByName(
        this.pluginInfo.pluginParseInfo.labelResName, this.pluginInfo.pluginParseInfo.bundleName)
        .then((result) => {
          this.name = result;
        })
    }
    if (this.eventMgr === undefined) {
      this.eventMgr = EvtBus.createEventManager();
    }
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        this.animateScale = HoverConstants.HOVER_DEFAULT_SCALE;
      }
    });
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear slot: ' + this.slot);
    if (this.eventMgr !== undefined) {
      this.eventMgr.offAll();
    }
  }

  @Builder
  buildSubPanelPluginToggle() {
    Column() {
      PluginComponent({
        template: {
          source: this.pluginInfo.pluginParseInfo.pluginTemplateName,
          bundleName: this.pluginInfo.pluginParseInfo.bundleName
        },
        data: this.getPluginData()
      })
        .width('100%')
        .height((this.isDragging ?
          this.dragCircleHeight : this.circleHeight) + this.iconMarginTop + this.iconMarginBottom)
        .onClick(this.onIconClick)
        .id(COMPONENT_ID + this.slot)
        .onHover(this.onIconHover)
        .onError((info) => {
          log.showInfo(`buildSubPanelPluginToggle loaded failed, err: ${info?.msg}`);
        })
      Row() {
        Text(this.name).draggable(false)
          .fontSize(this.titleSize)
          .fontColor(ToggleStyle.getStyle().titleColor)
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .padding({
            right: this.textMargin
          })
          .id(COMPONENT_ID_TEXT + this.slot)
        Image($r('app.media.ic_sub_panel')).draggable(false)
          .fillColor($r('sys.color.ohos_id_color_secondary'))
          .width(this.subPanelSize)
          .height(this.subPanelSize)
          .margin({
            bottom: 2
          })
          .id(COMPONENT_ID_ARROW + this.slot)
      }
      .constraintSize({
        minWidth: this.circleWidth,
        maxWidth: this.cellWidth
      })
      .onClick(this.onLabelClick)
      .alignItems(VerticalAlign.Bottom)
      .justifyContent(FlexAlign.End)
      .margin({
        left: this.textMargin,
        right: this.textMargin,
        bottom: this.topIconPadding
      })
    }
    .alignItems(HorizontalAlign.Center)
    .height(this.cellHeight)
    .geometryTransition(this.slot)
    .gesture(LongPressGesture({
      repeat: false
    }).onAction(this.onIconLongClick))
    .scale({ x: this.animateScale, y: this.animateScale })
    .onHover(this.onHoverChanged)
  }

  @Builder
  buildEditModeSubPanelPluginToggle() {
    Column() {
      PluginComponent({
        template: {
          source: this.pluginInfo.pluginParseInfo.pluginTemplateName,
          bundleName: this.pluginInfo.pluginParseInfo.bundleName
        },
        data: this.getPluginData()
      })
        .width('100%')
        .height((this.isDragging ?
          this.dragCircleHeight : this.circleHeight) + this.iconMarginTop + this.iconMarginBottom)
        .id(COMPONENT_ID + this.slot)
        .onHover(this.onIconHover)
        .onError((info) => {
          log.showInfo(`buildEditModeSubPanelPluginToggle loaded failed, err: ${info?.msg}`);
        })
      Row() {
        Text(this.name).draggable(false)
          .fontSize(this.titleSize)
          .fontColor(ToggleStyle.getStyle().titleColor)
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .id(COMPONENT_ID_TEXT + this.slot)
      }
      .width(this.cellWidth)
      .constraintSize({
        maxWidth: this.cellWidth
      })
      .alignItems(VerticalAlign.Bottom)
      .justifyContent(FlexAlign.Center)
      .padding({
        left: this.textMargin,
        right: this.textMargin,
        bottom: this.topIconPadding
      })
    }
    .alignItems(HorizontalAlign.Center)
    .height(this.cellHeight)
    .onClick(this.onIconClick)
    .scale({ x: this.animateScale, y: this.animateScale })
  }

  @Builder
  buildCommonEditModePluginToggle() {
    Column() {
      PluginComponent({
        template: {
          source: this.pluginInfo.pluginParseInfo.pluginTemplateName,
          bundleName: this.pluginInfo.pluginParseInfo.bundleName
        },
        data: this.isNewStyle ? this.getNewStylePluginData() : this.getPluginData()
      })
        .width('100%')
        .height(this.cellHeight)
        .id(COMPONENT_ID + this.slot)
        .onHover(this.onIconHover)
        .onError((info) => {
          log.showInfo(`buildCommonEditModePluginToggle loaded failed, err: ${info?.msg}`);
        })
    }
    .onClick(this.onIconClick)
    .scale({ x: this.animateScale, y: this.animateScale })
  }

  @Builder
  buildCommonPluginToggle() {
    Stack({ alignContent: this.isNewStyle && this.isPC ? Alignment.Bottom : Alignment.Center }) {
      Column() {
        PluginComponent({
          template: {
            source: this.pluginInfo.pluginParseInfo.pluginTemplateName,
            bundleName: this.pluginInfo.pluginParseInfo.bundleName
          },
          data: this.isNewStyle ? this.getNewStylePluginData() : this.getPluginData()
        })
          .clip(false)
          .width(this.buttonDiameter + this.newIconPadding * 2)
          .height(this.buttonDiameter + this.labelLineHeight + this.buttonLabelSpace + this.newIconPadding)
          .id(COMPONENT_ID + this.slot)
          .padding({
            top: this.pluginComponentPadding,
            right: this.pluginComponentRightPadding
          })
          .onComplete(() => {
            log.showInfo('plugin load complete');
            setTimeout(() => {
              this.onLockStatusChanged();
            }, NOTIFY_LOCK_STATUS_DELAY);
          })
          .onHover(this.onIconHover)
          .onError((info) => {
            log.showInfo(`buildCommonPluginToggle loaded failed, err: ${info?.msg}`);
          })
      }
      .gesture(LongPressGesture({
        repeat: false
      }).onAction(this.onIconLongClick))

      if (this.isPC) {
        Column() {
        }.width(this.buttonDiameter + this.newIconPadding * 2)
        .height(this.isNewStyle ? this.labelLineHeight + this.buttonLabelSpace : '38%')
        .onClick(this.onLabelClick)
      }
    }
    .height('100%')
    .scale({ x: this.animateScale, y: this.animateScale })
    .onHover(this.onHoverChanged)
  }

  build() {
    // plugin组件可见性
    if (!CommonUtils.isInvalid(this.pluginInfo?.pluginParseInfo?.pluginTemplateName) && DeviceHelper.isPC()) {
      if (this.isEditMode) {
        if (!CommonUtils.isEmpty(this.name) && this.pluginInfo.hasSubPage()) {
          this.buildEditModeSubPanelPluginToggle()
        } else {
          this.buildCommonEditModePluginToggle();
        }
      } else {
        if (!CommonUtils.isEmpty(this.name) && this.pluginInfo.hasSubPage()) {
          this.buildSubPanelPluginToggle();
        } else {
          this.buildCommonPluginToggle();
        }
      }
    }
  }

  onLockStatusChanged(): void {
    let controller: PluginToggleController = this.controller as PluginToggleController;
    if (controller?.updatePluginData) {
      log.info(`lock status changed: ${this.lockStatus} ${controller.slot}`);
      controller.updatePluginData(this.lockStatus == ScreenLockStatus.LOCKING ? 'LOCKING' : 'UNLOCK');
    } else {
      log.error('send lock status failed');
    }
  }

  /**
   * 点击标题弹出二级页面
   *
   * @param event 点击事件
   */
  onLabelClick = (event?: ClickEvent) => {
    log.showInfo('show sub page');
    if (this.controller) {
      this.controller.handleLabelClick(this.pluginInfo.pluginParseInfo.pluginSlot);
    }
  }

  /**
   * 图标hover动效
   *
   * @param event 悬浮事件
   */
  onIconHover = (isHover?: boolean) => {
    if (isHover === undefined) {
      return;
    }
    animateTo({
      duration: HoverConstants.HOVER_ANIMATE_DURATION,
      curve: Curve.Sharp
    }, () => {
      this.animateScale = isHover ? HoverConstants.HOVER_QUICK_BTN_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
    });
  }

  /**
   * 图标hover效果
   *
   * @param event 悬浮事件
   */
  onHoverChanged = (isHover?: boolean) => {
    if (isHover === undefined || !this.needHover() || this.isHover == isHover) {
      return;
    }
    this.isHover = isHover;
    log.showInfo(`hoverchanged ishover : ${this.isHover}`)
    if (this.controller) {
      this.controller.handleHover(this.isHover);
    }
  }

  /**
   * 开关点击事件
   *
   * @param event 事件
   */
  onIconClick = (event?: ClickEvent) => {
    // 上报开关点击事件
    HiDfxEventUtil.reportToggleClick(this.slot, HiDfxEventUtil.TOGGLE_TYPE_CLICK);
    if (this.controller && this.controller.handleOneClick()) {
      return;
    }
    log.showInfo('onIconClick slot:' + this.slot);
  }

  /**
   * 开关长按事件
   *
   * @param event 事件
   */
  onIconLongClick = (event?: GestureEvent) => {
    if (this.isEditMode || (this.controller && this.controller.handleLongClick())) {
      return;
    }
    // 上报开关长按事件
    HiDfxEventUtil.reportToggleClick(this.slot, HiDfxEventUtil.TOGGLE_TYPE_LONG_CLICK);
    log.showInfo('onIconLongClick slot: ' + this.slot);
    this.isLongClick = !this.isLongClick;
  }

  /**
   * plugin组件传递参数
   * 已有参数基础上，增加systemui业务属性
   */
  private getPluginData(): PCM.KVObject {
    let data = this.pluginInfo?.pluginData;
    if (!data) {
      data = {};
    }

    data[PLUGIN_KEY_CLICK] = this.isClick;
    data[PLUGIN_KEY_LONG_CLICK] = this.isLongClick;

    data[PLUGIN_KEY_DRAGMODE] = this.isDragging;
    data[PLUGIN_KEY_ICONHOVER] = this.isIconHover;
    data[PLUGIN_KEY_LABELHOVER] = this.isLabelHover;

    data[PLUGIN_KEY_CELLWIDTH] = this.cellWidth;
    data[PLUGIN_KEY_CELLHEIGHT] = this.cellWidth;
    data[PLUGIN_KEY_CIRCLEWIDTH] = this.circleWidth;
    data[PLUGIN_KEY_CIRCLEHEIGHT] = this.circleHeight;
    data[PLUGIN_KEY_ICONWIDTH] = this.iconWidth;
    data[PLUGIN_KEY_ICONHEIGHT] = this.iconHeight;
    data[PLUGIN_KEY_DRAGCIRCLEWIDTH] = this.dragCircleWidth;
    data[PLUGIN_KEY_DRAGCIRCLEHEIGHT] = this.dragCircleHeight;
    data[PLUGIN_KEY_DRAGICONWIDTH] = this.dragIconWidth;
    data[PLUGIN_KEY_DRAGICONHEIGHT] = this.dragIconHeight;
    data[PLUGIN_KEY_ICONOFFBG] = this.iconOffBG;
    data[PLUGIN_KEY_ICONONBG] = this.iconOnBG;
    data[PLUGIN_KEY_ICONONCOLOR] = this.iconOnColor;
    data[PLUGIN_KEY_ICONOFFCOLOR] = this.iconOffColor;
    data[PLUGIN_KEY_ICONMARGINTOP] = this.iconMarginTop;
    data[PLUGIN_KEY_ICONMARGINBOTTOM] = this.iconMarginBottom;
    data[PLUGIN_KEY_TITLESIZE] = this.titleSize;
    data[PLUGIN_KEY_TITLECOLOR] = this.titleColor;
    data[PLUGIN_KEY_TEXTHOVERWIDTH] = this.textHoverWidth;
    data[PLUGIN_KEY_TEXTHOVERHEIGHT] = this.textHoverHeight;
    data[PLUGIN_KEY_TEXTHOVERRADIUS] = this.textHoverRadius;
    data[PLUGIN_KEY_HOVERCOLOR] = this.hoverColor;
    data[PLUGIN_KEY_TRANSPARENTCOLOR] = this.transparentColor;
    data['iconOnBrightness'] = 1;
    data['iconOffBrightness'] = 1;
    data['iconBGOnBrightness'] = 1;
    data['iconBGOffBrightness'] = 1;
    data['rateOnValue'] = 0;
    data['rateOffValue'] = 0;
    data['lightUpDegreeOnValue'] = 0;
    data['lightUpDegreeOffValue'] = 0;
    return data;
  }

  private getNewStylePluginData(): PCM.KVObject {
    log.showInfo(`iconMarginBottom: ${this.iconMarginBottom}`);
    let data = this.pluginInfo?.pluginData;
    if (!data) {
      data = {};
    }

    data[PLUGIN_KEY_CLICK] = this.isClick;
    data[PLUGIN_KEY_LONG_CLICK] = this.isLongClick;

    data[PLUGIN_KEY_DRAGMODE] = this.isDragging;
    data[PLUGIN_KEY_ICONHOVER] = this.isIconHover;
    data[PLUGIN_KEY_LABELHOVER] = this.isLabelHover;

    data[PLUGIN_KEY_CELLWIDTH] = this.cellWidth;
    data[PLUGIN_KEY_CELLHEIGHT] = this.cellWidth;
    data[PLUGIN_KEY_CIRCLEWIDTH] = this.buttonDiameter;
    data[PLUGIN_KEY_CIRCLEHEIGHT] = this.buttonDiameter;
    data[PLUGIN_KEY_ICONWIDTH] = this.iconDiameter;
    data[PLUGIN_KEY_ICONHEIGHT] = this.iconDiameter;
    data[PLUGIN_KEY_DRAGCIRCLEWIDTH] = this.dragCircleWidth;
    data[PLUGIN_KEY_DRAGCIRCLEHEIGHT] = this.dragCircleHeight;
    data[PLUGIN_KEY_DRAGICONWIDTH] = this.dragIconWidth;
    data[PLUGIN_KEY_DRAGICONHEIGHT] = this.dragIconHeight;
    data[PLUGIN_KEY_ICONOFFBG] = this.newIconOffBGStr;
    data[PLUGIN_KEY_ICONONBG] = this.newIconOnBGStr;
    data[PLUGIN_KEY_ICONONCOLOR] = this.newIconOnColorStr;
    data[PLUGIN_KEY_ICONOFFCOLOR] = this.newIconOffColorStr;
    data[PLUGIN_KEY_ICONMARGINTOP] = 0;
    data[PLUGIN_KEY_ICONMARGINBOTTOM] = this.iconMarginBottom;
    data[PLUGIN_KEY_TITLESIZE] = this.labelFontSize;
    data[PLUGIN_KEY_TITLECOLOR] = this.labelFontColorStr;
    data[PLUGIN_KEY_TEXTHOVERWIDTH] = this.textHoverWidth;
    data[PLUGIN_KEY_TEXTHOVERHEIGHT] = this.textHoverHeight;
    data[PLUGIN_KEY_TEXTHOVERRADIUS] = this.textHoverRadius;
    data[PLUGIN_KEY_HOVERCOLOR] = this.hoverColor;
    data[PLUGIN_KEY_TRANSPARENTCOLOR] = this.transparentColor;
    data['iconOnBrightness'] = this.iconOnBrightness;
    data['iconOffBrightness'] = this.iconOffBrightness;
    data['iconBGOnBrightness'] = 1;
    data['iconBGOffBrightness'] = 1;
    data['iconBGShadowColor'] = this.iconBGShadowColor;
    data['iconBGShadowRadius'] = this.iconBGShadowRadius;
    data['iconBGShadowOffsetY'] = this.iconBGShadowOffsetY;
    data['rateOnValue'] = this.rateOnValue;
    data['rateOffValue'] = this.rateOffValue;
    data['lightUpDegreeOnValue'] = this.lightOnValue;
    data['lightUpDegreeOffValue'] = this.lightOffValue;
    return data;
  }

  private isClickBlocked() {
    if (this.isPC) {
      return HitTestMode.Default;
    }
    switch (this.slot) {
      case PluginSlot.SLOT_CONTROL_SHARE:
      case PluginSlot.SLOT_CONTROL_CAST:
      case PluginSlot.SLOT_CONTROL_DEVICE_COLLABORATION:
        return HitTestMode.Block;
      default:
        return HitTestMode.Default;
    }
  }

  private needHover(): boolean {
    switch (this.slot) {
      case PluginSlot.SLOT_CONTROL_SHARE:
        return true;
      default:
        return false;
    }
  }
}