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

import { display, LengthMetrics } from '@kit.ArkUI';
import osAccount from '@ohos.account.osAccount';
import type ctx from '@ohos.app.ability.common';
import { windowManager } from '@ohos/componentdrag/src/main/ets/manager/WindowManager';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { AppIconWithIndexSubIcon } from '../view/AppIconWithIndexSubIcon';
import { NotificationConfigEntity } from '../model/NotificationConfigEntity';
import { PinTopLimitDialogInterface, PinTopLimitDialogVmManager } from './PinTopLimitDialogInterface';
import { pinTopDialogConfigManager } from '../notification/vm/PinTopDialogConfigManager';
import measure from '@ohos.measure';
import { NtfPinTopLimitDialogConfig } from '../notification/vm/NtfPinTopLimitDialogConfig';
import screenSessionManager from '@ohos.screenSessionManager';
import { accessibility } from '@kit.AccessibilityKit';
import { DisplayAdapter } from '../adapter/DisplayAdapter';

const TAG = 'PinTopDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const COMPONENT_ID_REACH_LIMIT = TAG + '_Text_reachLimit';
const COMPONENT_ID_CONTENT = TAG + '_Text_Content';
const COMPONENT_ID_ICON = TAG + '_Item_Image_icon';
const COMPONENT_ID_RELATIVE_ICON = TAG + '_Item_Relative_Image_icon';
const COMPONENT_ID_NAME = TAG + '_Item_Text_name';
const COMPONENT_ID_SELECT = TAG + '_Item_Checkbox_select';
const COMPONENT_ID_CANCEL = TAG + '_Button_cancel';
const COMPONENT_ID_CONFIRM = TAG + '_Button_confirm';

const NTF_SETTING_DIALOG_ITEM_HEIGHT = 40;
const NTF_SETTING_DIALOG_CONTENT_LINE_HEIGHT = 21;
const NTF_SETTING_DIALOG_TITLE_HEIGHT = 56;
const NTF_PIN_TOP_APP_ICON_SIZE = 56;
const NTF_PIN_TOP_APP_ICON_MARGIN = 8;
const NTF_PIN_TOP_APP_ROW_MARGIN_GAP = 10;
const NTF_PIN_TOP_APP_NAME_LINE_HEIGHT = 16;
const NTF_PIN_TOP_APP_LAYOUT_MARGIN = 20;
const NTF_PIN_TOP_APP_DIALOG_CONTENT_PADDING_OUTER_HOME = 4;
const NTF_MENU_DIALOG_TEXT_PADDING = 24;
const NTF_PIN_TOP_PADDING_LEFT_RIGHT = 16;
const NTF_LAND_HEIGHT_SCALE = 0.9;
const PIN_TOP_DIALOG_HEIGHT_PC = 378;
const PIN_TOP_DIALOG_WIDTH_PC = 400;

/**
 * 滑动区最小高度，低于最小高度，整个页面可滑动
 */
const SCROLLER_MIN_HEIGHT = 100;
/**
 * 字体放大倍数界限，超过之后启用适老化布局
 */
const FONT_SIZE_LIMIT_SCALE_FOR_OLD = 1.75;

const BASE_LINE_DPI = 160;


export interface PinTopDialogOption {
  limit: number;
  onSelected: (selected: Set<PinTopAppItem>) => void;
  onCancel: () => void;
}

/**
 * 置顶通知超限的对话框
 *
 * @since 2023-02-10
 */
@CustomDialog
export default struct PinTopLimitDialog {
  @State
  pinTopConfigList: Array<PinTopAppItem> = [];
  @State
  dialogContentText: string = ''
  @State
  isEnable: boolean = false;
  controller?: CustomDialogController;
  onSelected: (selected: Set<PinTopAppItem>) => void = () => {
  };
  onCancel: () => void = () => {
  };
  operationList: Set<PinTopAppItem> = new Set();
  readonly limit: number = PIN_TOP_APPS_LIMIT;
  updateHeight: (height: number) => void = () => {
  };
  pinTopLimitDialogHeight: number = 450;
  ntfHeight: number = 0;
  dialogWidth: Length = '100%';
  private accountMgr?: osAccount.AccountManager;
  /**
   * 横竖屏转换
   */
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @Consume @Watch('refreshPinTopLimitDialog') pinTopLimitDialogClose: boolean;
  /**
   * 是否标题参与滑动
   */
  @State isTitleScroll: boolean = false;
  /**
   * 是否横屏布局
   */
  @State isLandLayout: boolean = false;
  /**
   * 是否文本参与滑动
   */
  @State isContentScroll: boolean = false;
  /**
   * 是否按钮参与滑动
   */
  @State isButtonScroll: boolean = false;
  /**
   * 折叠状态
   */
  @State foldStatus: display.FoldStatus = DisplayAdapter.getFoldStatus();
  /**
   * 设备高度
   */
  @State displayHeight: number = 0;
  /**
   * 是否所有组件均需要滑动
   */
  @State isAllScroll: boolean = false;
  /**
   * 状态栏高度
   */
  statusBarHeight: number = 0;
  /**
   * 横屏的最大高度
   */
  private landHeight: number = 0;
  /**
   * 当前窗口宽度
   */
  windowWidth: number = 0;
  /**
   * 当前窗口高度
   */
  windowHeight: number = 0;
  /**
   * 横屏时Grid的高度
   */
  private itemHeight: number = 0;

  /*
  手机/PC ui差异化参数
   */
  private ntfPinTopLimitDialogParams: NtfPinTopLimitDialogConfig =
    pinTopDialogConfigManager.getConfig();
  readonly colCount: number = this.ntfPinTopLimitDialogParams.colCount;
  readonly actionButtonWidth?: number = this.ntfPinTopLimitDialogParams.actionButtonWidth;

  pinTopLimitDialogVm?: PinTopLimitDialogInterface = PinTopLimitDialogVmManager.getVm();
  context?: ctx.ServiceExtensionContext | ctx.UIExtensionContext | ctx.Context = this.pinTopLimitDialogVm?.context;

  private refreshPinTopLimitDialog(): void {
    if (this.pinTopLimitDialogClose) {
      this.onCancel();
      this.controller?.close();
    }
  }

  /**
   * 初始化显示高度
   */
  private initHeight():void {
    try {
      this.displayHeight = px2vp(display.getDefaultDisplaySync().height);
    } catch (error) {
      log.error(`getDefaultDisplaySync fail, code = ${error?.code}, message = ${error?.message}`);
    }
    // 计算横屏显示高度
    this.landHeight = (this.displayHeight - this.statusBarHeight) * NTF_LAND_HEIGHT_SCALE;
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear')
    this.pinTopLimitDialogClose = false;
    this.initPinTopAppList();
    if (!this.windowWidth || !this.windowHeight) {
      this.windowWidth = windowManager.getWindowWidth();
      this.windowHeight = windowManager.getWindowHeight();
    }
    this.isAllScroll = this.getAllScrollState(this.windowHeight);
    // 初始化显示高度
    this.initHeight();
    this.dialogContentText =
      this.getPluralStringValue($r('app.plural.ntf_pin_top_dialog_reach_limit_content'), this.limit)
    if (this.isLandscape) {
      log.showInfo(`onDisplayHeightEvent, disHeight:${this.displayHeight}, \
landHeight:${this.landHeight}, statusBarHeight:${this.statusBarHeight}`);
      this.isLandLayout = this.pinTopLimitDialogVm?.getIsLandLayout() ?? false;
    }
    this.refreshIsScroll();

  }

  private onFoldStatusChange = (newStatus: display.FoldStatus) => {
    this.foldStatus = newStatus;
    this.refreshIsScroll();
  }

  /**
   * 获取多值资源字符串
   * @param resource 资源对象
   * @param count 计数
   * @return 返回解析的值为字符串
   * @throws 如果在获取资源字符串的过程中发生错误，将抛出异常
   */
  private getPluralStringValue(resource: Resource, count: number): string {
    try {
      return this.context?.resourceManager.getPluralStringValueSync(resource.id, count) ?? '';
    } catch (err) {
      log.error(`getPluralStringValueByAsync error `, err);
    }
    return '';
  }

  aboutToDisappear() {
    if (DeviceHelper.isPC()) {
      if (this.ntfHeight < this.pinTopLimitDialogHeight) {
        this.updateHeight(this.ntfHeight);
      }
    }

    log.showInfo('aboutToDisappear')
  }

  private getScaleSize(size: number): string {
    return size * (this.pinTopLimitDialogVm?.getFontScale() ?? 1) + 'vp';
  }

  private getScaleRate(): number {
    return this.pinTopLimitDialogVm?.getFontScale() ?? 1;
  }

  /**
   * 初始化置顶应用列表数据
   */
  async initPinTopAppList() {
    let pinTopAppList = await this.getPinTopList();
    this.pinTopConfigList = [];
    for (const item of pinTopAppList) {
      this.pinTopConfigList.push({
        appBundle: item.bundle,
        uid: item.uid,
        appName: item.label,
        appIcon: item.icon,
        isSelected: true,
        appIndex: item.appIndex
      });
    }
    this.isAllScroll = this.getAllScrollState(this.windowHeight);
    this.refreshIsScroll()
  }

  /**
   * 导入对象，Grid添加滑动条
   */
  scroller: Scroller = new Scroller()

  build() {
    GridRow({
      columns: 8,
      gutter: { x: this.ntfPinTopLimitDialogParams.ntfPinTopGridCloXGutter, y: 0 },
      breakpoints: { value: ['320vp', '520vp', '840vp'],
        reference: BreakpointsReference.ComponentSize },
      direction: GridRowDirection.Row
    }) {
      this.buildGridCol();
      GridCol(this.isContentScroll ? { span: { xs: 8, sm: 8, md: 6, lg: 6 } } :
        { span: { xs: 8, sm: 8, md: 4, lg: 4 } }) {
        Stack({ alignContent: Alignment.Center }) {
          Column() {
            if (!this.isTitleScroll) {
              this.buildTitleContent();
            }
            if (!this.isContentScroll) {
              this.buildDialogContent();
            }
            Grid(this.scroller) {
              if (this.isContentScroll) {
                GridItem() {
                  Column() {
                    if (this.isTitleScroll) {
                      this.buildTitleContent();
                    }
                    this.buildDialogContent();
                  }
                }
                .width('100%')
                .columnStart(0)
                .columnEnd(this.colCount - 1)
              }
              ForEach(this.pinTopConfigList, (item: PinTopAppItem, index?: number) => {
                GridItem() {
                  RelativeContainer() {
                    AppIconWithIndexSubIcon({
                      appIcon: item.appIcon,
                      index: item.appIndex,
                      appIconId: COMPONENT_ID_ICON,
                      appIconSize: this.ntfPinTopLimitDialogParams.ntfPinTopAppIconSize,
                      appIconMargin: this.ntfPinTopLimitDialogParams.ntfPinTopAppIconMargin
                    })
                      .id(COMPONENT_ID_RELATIVE_ICON)
                      .alignRules({
                        middle: { anchor: '__container__', align: HorizontalAlign.Center }
                      })
                      .constraintSize({
                        minWidth: this.ntfPinTopLimitDialogParams.ntfPinTopAppIconConstraintSize,
                        minHeight: this.ntfPinTopLimitDialogParams.ntfPinTopAppIconConstraintSize
                      })
                      .padding({
                        end: LengthMetrics.vp(0),
                      })
                      .margin({ top: this.ntfPinTopLimitDialogParams.ntfAppIconTopMargin })

                    Checkbox()
                      .id(COMPONENT_ID_SELECT)
                      .select(item.isSelected)
                      .onChange((isSelected: boolean) => {
                        item.isSelected = isSelected;
                        if (item.isSelected) {
                          this.operationList.delete(item);
                        } else {
                          this.operationList.add(item)
                        }
                        this.isEnable = this.operationList.size > 0;
                      })
                      .selectedColor($r('sys.color.comp_background_emphasize'))
                      .alignRules({
                        'middle': { 'anchor': COMPONENT_ID_RELATIVE_ICON, 'align': HorizontalAlign.Center },
                        'center': { 'anchor': COMPONENT_ID_RELATIVE_ICON, 'align': VerticalAlign.Top }
                      })
                      .offset({
                        start: LengthMetrics.vp(this.ntfPinTopLimitDialogParams.ntfPinTopAppIconCheckboxOffsetStart),
                        top: LengthMetrics.vp(this.ntfPinTopLimitDialogParams.ntfPinTopAppIconCheckboxOffsetTop)
                      })
                      .width(this.ntfPinTopLimitDialogParams.ntfPinTopAppIconCheckboxWidth)
                      .height(this.ntfPinTopLimitDialogParams.ntfPinTopAppIconCheckboxHeight)

                    Text(item.appName)
                      .draggable(false)
                      .id(COMPONENT_ID_NAME)
                      .fontSize(this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfPinTopAppNameFontSize))
                      .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
                      .lineHeight(this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfPinTopAppNameLineHeight))
                      .maxFontSize(this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfPinTopAppNameMaxFontSize))
                      .minFontSize(this.ntfPinTopLimitDialogParams.ntfPinTopAppNameMinFontSize)
                      .maxLines(1)
                      .textOverflow({
                        overflow: TextOverflow.Ellipsis
                      })
                      .fontWeight(FontWeight.Medium)
                      .alignRules({
                        'top': { 'anchor': COMPONENT_ID_RELATIVE_ICON, 'align': VerticalAlign.Bottom },
                        'middle': { 'anchor': COMPONENT_ID_RELATIVE_ICON, 'align': HorizontalAlign.Center }
                      })
                      .margin({
                        top: this.ntfPinTopLimitDialogParams.ntfPinTopAppNameTopMargin
                      })
                  }
                  .height('auto')
                }
              })
              if (this.isButtonScroll) {
                GridItem() {
                  this.buildActionButton();
                }.width('100%').columnStart(0).columnEnd(this.colCount - 1);
              }
            }
            .columnsTemplate(this.gridColumnTemplate())
            .columnsGap(this.ntfPinTopLimitDialogParams.ntfGridColumnsGap)
            .rowsGap(this.ntfPinTopLimitDialogParams.ntfGridRowsGap)
            .height(this.getGridLayoutHeight())
            .padding(this.isTitleScroll ? {
              left: 16,
              right: 16,
            } :
            {
              top: this.ntfPinTopLimitDialogParams.dialogTextTopPadding,
              bottom: this.ntfPinTopLimitDialogParams.dialogTextBottomPadding,
              left: this.ntfPinTopLimitDialogParams.ntfMenuDialogTextPadding,
              right: this.ntfPinTopLimitDialogParams.dialogTextRightPadding,
            })
            .borderRadius(this.isTitleScroll ? $r('sys.float.corner_radius_level16') : 0)

            if (!this.isButtonScroll) {
              this.buildActionButton();
            }
          }
          .width(this.dialogWidth)
          .padding(this.isTitleScroll ?
            {
              top: this.getIsOuterHome() ? NTF_PIN_TOP_APP_DIALOG_CONTENT_PADDING_OUTER_HOME : 0,
            } : undefined)
          .backgroundColor(this.ntfPinTopLimitDialogParams.dialogBgColor !== undefined ?
          this.ntfPinTopLimitDialogParams.dialogBgColor : $r('sys.color.ohos_id_color_dialog_bg'))
          .backgroundBlurStyle(this.ntfPinTopLimitDialogParams.dialogBgColor === undefined ? BlurStyle.NONE :
          BlurStyle.COMPONENT_ULTRA_THICK, {
            colorMode: ThemeColorMode.DARK
          })
          .borderRadius(this.ntfPinTopLimitDialogParams.ntfMenuDialogRadio)
          .margin({
            left: $r('sys.float.ohos_id_dialog_margin_start'),
            right: $r('sys.float.ohos_id_dialog_margin_end')
          })
        }
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          if (newValue?.height) {
            this.windowHeight = Number(newValue.height);
          }
          this.isAllScroll = this.getAllScrollState(this.windowHeight);
          this.refreshIsScroll();
        })
        .width('100%')
        .height('100%')
        .padding({
          left: this.isLandLayout ? 0 : this.ntfPinTopLimitDialogParams.dialogGridcolPadding,
          right: this.isLandLayout ? 0 : this.ntfPinTopLimitDialogParams.dialogGridcolPadding
        })
      }
      this.buildGridCol();
    }
    .layoutWeight(1)
    .width('100%')
    .height('100%')
    .margin({ left: this.isLandLayout ? this.ntfPinTopLimitDialogParams.dialogGridrowMargin : 0,
      right: this.isLandLayout ? this.ntfPinTopLimitDialogParams.dialogGridrowMargin : 0 })
    .onFocus(this.pinTopLimitDialogVm?.onFocus)
    .onBlur(this.pinTopLimitDialogVm?.onBlur)
    .onSizeChange(() => {
    })
    .backgroundColor(this.ntfPinTopLimitDialogParams.dialogMaskBgColor)
  }

  @Builder
  buildGridCol() {
    GridCol(this.isContentScroll ? { span: { xs: 0, sm: 0, md: 1, lg: 1 } } :
      { span: { xs: 0, sm: 0, md: 2, lg: 2 } }) {
      Column() {
      }.width('100%').height('100%')
    }
  }

  @Builder
  buildTitleContent() {
    Text($r('app.string.ntf_pin_top_dialog_reach_limit_title'))
      .draggable(false)
      .id(COMPONENT_ID_REACH_LIMIT)
      .width('100%')
      .textAlign(this.ntfPinTopLimitDialogParams.ntfTitleContentAlign)
      .height(this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfSettingDialogTitleHeight))
      .fontSize(this.getScaleSize(this.ntfPinTopLimitDialogParams.titleContentFontSize))
      .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
      .fontWeight(FontWeight.Bold)
      .padding({
        top: this.ntfPinTopLimitDialogParams.dialogTextVerticalPadding,
        bottom: this.ntfPinTopLimitDialogParams.dialogTextVerticalPadding,
        left: this.ntfPinTopLimitDialogParams.ntfMenuDialogTextPadding,
        right: this.ntfPinTopLimitDialogParams.ntfMenuDialogTextPadding,
      })
      .margin({
        top: this.ntfPinTopLimitDialogParams.ntfTitleContentTopMargin
      })
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(2)
      .onAppear(() => {
        this.requestFocusDelay(COMPONENT_ID_REACH_LIMIT);
      })
  }

  // 无障碍延时聚焦
  public async requestFocusDelay(customId: string): Promise<void> {
    if (!accessibility.isOpenAccessibilitySync()) {
      log.info(TAG, 'not open accessibility.');
      return;
    }
    if (customId) {
      try {
        let eventInfo: accessibility.EventInfo = ({
          type: 'requestFocusForAccessibility',
          bundleName: 'com.ohos.sceneboard',
          triggerAction: 'common',
          customId: customId
        });
        await accessibility.sendAccessibilityEvent(eventInfo);
        log.info(TAG, 'requestFocusForAccessibility finished.');
      } catch (e) {
        log.error(TAG, 'requestFocusForAccessibility error, code = {0}, message = {1}', e?.code, e?.message);
      }
    }
  }

  async requestFocusAccessibility(customId: string): Promise<void> {
    log.showInfo(`requestFocusAccessibility ${customId}`)
    try {
      await accessibility.sendAccessibilityEvent({
        type: 'requestFocusForAccessibility',
        bundleName: 'com.ohos.sceneboard',
        triggerAction: 'common',
        customId: customId,
      });
    } catch (err) {
      log.showError(`requestFocusAccessibility failed, Code is ${err.code}, message is ${err.message}`);
    }
  }

  @Builder
  buildDialogContent() {
    Text(this.dialogContentText).draggable(false)
      .id(COMPONENT_ID_CONTENT)
      .textAlign(TextAlign.Start)
      .fontSize(this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfDialogContentFontSize))
      .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
      .lineHeight(this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfDialogContentLineHeight))
      .fontWeight(FontWeight.Medium)
      .width('100%')
      .padding({
        left: this.getIsOuterHome() ? 0 : this.ntfPinTopLimitDialogParams.ntfMenuDialogTextPadding,
        right: this.getIsOuterHome() ? 0 : this.ntfPinTopLimitDialogParams.ntfMenuDialogTextPadding,
      })
  }

  @Styles
  actionButtonCommonStyle(){
    .height(this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfSettingDialogItemHeight))
    .width(this.actionButtonWidth === undefined ? '100%' : this.getScaleSize(this.actionButtonWidth))
    .backgroundColor(this.ntfPinTopLimitDialogParams.actionButtonBkgColor)
    .layoutWeight(1)
    // 非PC设备按钮类型为Capsule,borderRadius属性不生效,该属性为PC特别处理
    .borderRadius($r('sys.float.corner_radius_level4'))
  }

  @Builder
  buildActionButton() {
    Row() {
      Button($r('app.string.cancel'), { type: this.ntfPinTopLimitDialogParams.actionButtonType })
        .id(COMPONENT_ID_CANCEL)
        .fontSize(this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfActionButtonFontSize !== undefined ?
        this.ntfPinTopLimitDialogParams.ntfActionButtonFontSize :
        LengthMetrics.resource($r('sys.float.ohos_id_text_size_button1')).value))
        .fontColor(this.ntfPinTopLimitDialogParams.ntfActionButtonFontColor !== undefined ?
        this.ntfPinTopLimitDialogParams.ntfActionButtonFontColor : $r('sys.color.ohos_id_color_text_primary_activated'))
        .fontWeight(FontWeight.Medium)
        .actionButtonCommonStyle()
        .onClick(() => {
          this.pinTopLimitDialogClose = true;
        })
        .margin({
          top: this.ntfPinTopLimitDialogParams.buttonTopMargin,
          bottom: this.ntfPinTopLimitDialogParams.buttonBottomMargin,
          left: this.ntfPinTopLimitDialogParams.buttonRowOutMargin,
          right: this.ntfPinTopLimitDialogParams.buttonRowInnerMargin
        })
      Line()
        .width('1px')
        .height('24vp')
        .backgroundColor($r('sys.color.ohos_id_color_list_separator'))
        .margin({ left: 8, right: 8 })
        .visibility(this.ntfPinTopLimitDialogParams.buttonInnerLineVisibility)
      Button($r('app.string.confirm'), { type: this.ntfPinTopLimitDialogParams.actionButtonType })
        .id(COMPONENT_ID_CONFIRM)
        .fontSize(this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfActionButtonFontSize !== undefined ?
        this.ntfPinTopLimitDialogParams.ntfActionButtonFontSize :
        LengthMetrics.resource($r('sys.float.ohos_id_text_size_button1')).value))
        .fontColor(this.ntfPinTopLimitDialogParams.ntfActionButtonFontColor !== undefined ?
        this.ntfPinTopLimitDialogParams.ntfActionButtonFontColor : $r('sys.color.ohos_id_color_text_primary_activated'))
        .fontWeight(FontWeight.Medium)
        .onClick(() => {
          this.onSelected(this.operationList);
        })
        .enabled(this.ntfPinTopLimitDialogParams.buttonEnabled ?? this.isEnable)
        .opacity(this.ntfPinTopLimitDialogParams.buttonOpacity ?? this.isEnable ? 1 :
        this.ntfPinTopLimitDialogParams.buttonUnableOpacity)
        .actionButtonCommonStyle()
        .margin({
          top: this.ntfPinTopLimitDialogParams.buttonTopMargin,
          bottom: this.ntfPinTopLimitDialogParams.buttonBottomMargin,
          left: this.ntfPinTopLimitDialogParams.buttonRowInnerMargin,
          right: this.ntfPinTopLimitDialogParams.buttonRowOutMargin
        })
    }
    .margin({
      top: this.ntfPinTopLimitDialogParams.buttonOutTopMargin,
      bottom: this.ntfPinTopLimitDialogParams.buttonOutTopMargin,
      left: this.ntfPinTopLimitDialogParams.buttonOutBottomRightLeftMargin,
      right: this.ntfPinTopLimitDialogParams.buttonOutBottomRightLeftMargin
    })
    .alignItems(VerticalAlign.Center)
  }

  /**
   * 是否是外屏
   */
  private getIsOuterHome(): boolean {
    return this.foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED;
  }

  /**
   * 获取图标容器高度
   */
  private getGridLayoutHeight(): Length {
    if (this.getIsOuterHome()) {
      // 屏幕高度90%
      const disHeight = this.displayHeight * NTF_LAND_HEIGHT_SCALE;
      const gridLayoutHeight = disHeight - this.getButtonHeight() - NTF_PIN_TOP_APP_DIALOG_CONTENT_PADDING_OUTER_HOME;
      log.showInfo(`gridLayoutHeight disHeight: ${disHeight} gridLayoutHeight: ${gridLayoutHeight}`);
      return gridLayoutHeight;
    }
    if (this.isAllScroll && !this.isLandLayout) {
      return '100%';
    }
    return this.isLandLayout ? this.gridLandHeight() : this.gridLayoutHeight()
  }

  /**
   * 获取按钮高度 等于 按钮本体高度 + 上边距 + 下边距
   */
  private getButtonHeight(): number {
    return this.getScaleRate() * NTF_SETTING_DIALOG_ITEM_HEIGHT +
      this.ntfPinTopLimitDialogParams.buttonOutTopMargin +
      this.ntfPinTopLimitDialogParams.buttonOutBottomRightLeftMargin;
  }

  /**
   * 获取标题高度
   */
  private getTitleHeight(): number {
    return this.getScaleRate() * this.ntfPinTopLimitDialogParams.ntfSettingDialogTitleHeight;
  }

  gridLandHeight(): number {
    // 按钮高度
    let buttonHeight = this.getButtonHeight();
    this.itemHeight = this.landHeight - this.getTitleHeight() - buttonHeight;
    // 适老化布局时，宽度小于100vp，全部区域可滑动
    if (this.isContentScroll && this.itemHeight < SCROLLER_MIN_HEIGHT) {
      this.itemHeight = this.landHeight;
      log.showInfo(`gridLandHeight, itemHeight:${this.itemHeight}, landHeight:${this.landHeight}`);
      return this.itemHeight;
    }
    if (!this.isContentScroll) {
      // 副标题高度
      let contentHeight = this.getScaleRate() * this.ntfPinTopLimitDialogParams.ntfSettingDialogContentLineHeight * 2;
      // 非适老化布局，副标题放在滑动区外面
      this.itemHeight = this.itemHeight - contentHeight;
    }
    log.showInfo(`gridLandHeight, itemHeight:${this.itemHeight}, landHeight:${this.landHeight}`);
    return this.itemHeight;
  }

  private getContentHeightPx(): number {
    // md（520vp）以上设备，显示宽度为窗口1/2；
    let baseWidth = this.windowWidth > 520 ? this.windowWidth / 2 -
    this.ntfPinTopLimitDialogParams.ntfPinTopGridCloXGutter : this.windowWidth;
    let textWidth = DeviceHelper.isPC() ? PIN_TOP_DIALOG_WIDTH_PC - NTF_MENU_DIALOG_TEXT_PADDING * 2 :
      baseWidth - this.ntfPinTopLimitDialogParams.ntfPinTopPaddingLeftRight * 2 -
        this.ntfPinTopLimitDialogParams.ntfMenuDialogTextPadding * 2;
    let contentHeightPx =
      this.getTextSizeOptions(this.dialogContentText, FontWeight.Medium,
        this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfDialogContentFontSize),
        this.getScaleSize(this.ntfPinTopLimitDialogParams.ntfDialogContentLineHeight), textWidth).height as number;
    return contentHeightPx;
  }

  gridLayoutHeight(): number {
    let contentHeightPx = this.getContentHeightPx();
    let contentHeight = px2vp(contentHeightPx);
    let titleHeight = this.getTitleHeight();
    let buttonHeight = this.getButtonHeight();
    // 图标区域可设置的最大高度
    let maxHeight = this.landHeight - titleHeight - buttonHeight - contentHeight;
    if (DeviceHelper.isPC()) {
      return PIN_TOP_DIALOG_HEIGHT_PC - titleHeight - buttonHeight - (contentHeightPx /
        (screenSessionManager.getPrimaryDisplaySystemDpi() / BASE_LINE_DPI));
    }
    let rowCount = Math.ceil(this.pinTopConfigList.length / this.colCount);
    let itemHeight = this.ntfPinTopLimitDialogParams.ntfPinTopAppIconSize +
      this.ntfPinTopLimitDialogParams.ntfPinTopAppIconMargin * 2 +
    this.ntfPinTopLimitDialogParams.ntfPinTopAppNameTopMargin +
    this.ntfPinTopLimitDialogParams.ntfPinTopAppNameLineHeight;
    let totalRowsHeight = itemHeight * rowCount;
    let totalGapHeight = this.ntfPinTopLimitDialogParams.ntfPinTopAppIconRowMarginGap * (rowCount - 1)
    let verticalTotalPadding = this.ntfPinTopLimitDialogParams.ntfPinTopAppLayoutMargin * 2;
    let height = totalRowsHeight + totalGapHeight + verticalTotalPadding;
    // 超过最大高度时取最大高度
    return height > maxHeight ? maxHeight : height;
  }

  /**
   * 获取正常竖屏时弹窗子组件高度和
   * @returns
   */
  private getAllSubcomponentHeight(): number {
    const allSubcomponentHeight: number =
      this.getTitleHeight() + px2vp(this.getContentHeightPx()) + this.gridLayoutHeight() + this.getButtonHeight();
    return allSubcomponentHeight;
  }

  private getAllScrollState(height: number): boolean {
    return this.getAllSubcomponentHeight() >= height;
  }

  /**
   * 开关面板列数排布
   *
   * @param column 列数
   */
  gridRowTemplate(): string {
    let rowCount = Math.ceil(this.pinTopConfigList.length / this.colCount);
    return this.template(rowCount);
  }

  gridColumnTemplate(): string {
    return this.template(this.colCount);
  }

  template(count: number): string {
    let template = '1fr';
    for (let i = 1; i < count; i++) {
      template += ' 1fr';
    }
    return template;
  }

  /**
   * 刷新组件是否滑动
   */
  private refreshIsScroll(): void {
    this.isContentScroll = this.getIsContentScroll();
    this.isTitleScroll = this.getIsTitleScroll();
    this.isButtonScroll = this.getIsButtonScroll();
  }

  /**
   * 是否文本参与滑动
   */
  private getIsContentScroll(): boolean {
    if (this.getIsOuterHome()) {
      return true;
    }
    if (!this.isLandLayout) {
      if (this.isAllScroll) {
        return true;
      }
      return false;
    }
    // 大于等于界限，启用适老化布局
    return (this.pinTopLimitDialogVm?.getFontScale() ?? 1) >= FONT_SIZE_LIMIT_SCALE_FOR_OLD;
  }

  /**
   * 是否标题参与滑动
   */
  private getIsTitleScroll(): boolean {
    if (this.getIsOuterHome()) {
      return true;
    }
    if (this.isAllScroll) {
      return true;
    }
    if (!this.isContentScroll) {
      return false;
    }
    let gridHeight = this.landHeight - this.getTitleHeight() - this.getButtonHeight();
    return gridHeight < SCROLLER_MIN_HEIGHT;
  }

  /**
   * 是否按钮参与滑动
   */
  private getIsButtonScroll(): boolean {
    if (this.getIsOuterHome()) {
      return false;
    }
    if (this.isAllScroll) {
      return true;
    }
    return this.isTitleScroll;
  }

  /**
   * 获取置顶的应用列表
   * @returns
   */
  public async getPinTopList(): Promise<NotificationConfigEntity[]> {
    let userId = this.getUserId();
    const predicates = NotificationConfigEntity.getPredicates();
    predicates.equalTo({ pinTop: true });
    predicates.inCondition({ userId: [userId, 0] });
    return NotificationConfigEntity.queryList(predicates);
  }

  /**
   * 获取当前活跃用户
   * @returns
   */
  private getUserId(): number {
    let uid: number = this.context?.applicationInfo.uid ?? 0;
    if (!this.accountMgr) {
      this.accountMgr = osAccount.getAccountManager();
    }
    return this.accountMgr.getOsAccountLocalIdForUidSync(uid);
  }

  private getTextSizeOptions(textContent: string | Resource, fontWeight: FontWeight, fontSize: string,
    lineHeight: string, constraintWidth?: number): SizeOptions {
    return measure.measureTextSize({
      textContent: textContent,
      fontWeight: fontWeight,
      fontSize: fontSize,
      lineHeight: lineHeight,
      constraintWidth: constraintWidth
    });
  }
}

/**
 * Grid子项的数据模型
 */
export class PinTopAppItem {
  public appBundle: string = '';
  public uid: number = 0;
  public appIcon: string | null = null;
  public appName: string = '';
  public isSelected: boolean = false;
  public appIndex: number = 0;
}

export const PIN_TOP_APPS_LIMIT = 5;