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
import { AppIconWithIndexSubIcon } from './AppIconWithIndexSubIcon';
import { ResourceVm } from '../vm/ResourceVm';
import { INotificationPinTopLimitDialogVm } from '../notification/interface/INotificationPinTopLimitDialogVm';
import { PinTopAppItem } from '../vm/NotificationPinTopLimitDialogVm';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = 'NotificationPinTopLimitDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const COMPONENT_ID_REACH_LIMIT = TAG + '_Text_reachLimit';
const COMPONENT_ID_CONTENT = TAG + '_Text_Content';
const COMPONENT_ID_ICON = TAG + '_Item_Image_icon';
const COMPONENT_ID_RELATIVE_ICON = TAG + '_Item_Relative_Image_icon';
const COMPONENT_ID_NAME = TAG + '_Item_Text_name';
const COMPONENT_ID_SELECT = TAG + '_Item_Checkbox_select';
const COMPONENT_ID_CANCEL = TAG + '_Button_cancel';
const COMPONENT_ID_CONFIRM = TAG + '_Button_confirm';

/**
 * 置顶通知超限的对话框
 *
 * @since 2024-11-15
 */
@CustomDialog
export struct NotificationPinTopLimitDialog {
  @State isEnable: boolean = false;
  controller?: CustomDialogController;
  pinTopDialogVm?: INotificationPinTopLimitDialogVm;
  operationList: Set<PinTopAppItem> = new Set();
  scroller: Scroller = new Scroller()
  gridColumnTemplate: string = '';

  private computeGridColumnTemplate(): void {
    let template = '1fr';
    for (let i = 1; i < this.pinTopDialogVm!.colCount; i++) {
      template += ' 1fr';
    }
    this.gridColumnTemplate = template;
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.computeGridColumnTemplate();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Column() {
      if (!this.pinTopDialogVm!.isAllScroll) {
        this.buildTitleContent();
      }
      if (!this.pinTopDialogVm!.isLandSuitableForOld && !this.pinTopDialogVm!.isAllScroll) {
        this.buildDialogContent();
      }
      Grid(this.scroller) {
        if (this.pinTopDialogVm!.isLandSuitableForOld || this.pinTopDialogVm!.isAllScroll) {
          GridItem() {
            Column() {
              if (this.pinTopDialogVm!.isAllScroll) {
                this.buildTitleContent();
              }
              this.buildDialogContent();
            }
          }
          .width('100%')
          .columnStart(0)
          .columnEnd(this.pinTopDialogVm!.colCount - 1)
        }

        ForEach(this.pinTopDialogVm?.pinTopConfigList, (item: PinTopAppItem, index?: number) => {
          GridItem() {
            RelativeContainer() {
              AppIconWithIndexSubIcon({
                appIcon: item.appIcon,
                index: item.appIndex,
                appIconId: COMPONENT_ID_ICON,
                appIconSize: LengthMetrics.resource($r('app.float.ntf_pin_top_app_icon_size')).value,
                appIconMargin: $r('app.float.ntf_pin_top_app_icon_margin'),
                subIconMargin: $r('app.float.ntf_pin_top_app_sub_icon_margin')
              })
                .id(COMPONENT_ID_RELATIVE_ICON)
                .alignRules({
                  middle: { anchor: '__container__', align: HorizontalAlign.Center }
                })
                .constraintSize({
                  minWidth: 72,
                  minHeight: 72
                })
                .margin({ top: $r('app.float.ntf_pin_top_app_padding') })

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
                  start: LengthMetrics.vp(24),
                  top: LengthMetrics.vp(12)
                })

              Text(item.appName)
                .draggable(false)
                .id(COMPONENT_ID_NAME)
                .fontSize($r('app.float.ntf_pin_top_app_name_font_size_fp'))
                .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
                .lineHeight($r('app.float.ntf_pin_top_app_name_line_height_fp'))
                .maxFontSize($r('app.float.ntf_pin_top_app_name_font_size_fp'))
                .minFontSize(10)
                .maxLines(1)
                .textOverflow({
                  overflow: TextOverflow.Ellipsis
                })
                .fontWeight(FontWeight.Medium)
                .alignRules({
                  'top': { 'anchor': COMPONENT_ID_RELATIVE_ICON, 'align': VerticalAlign.Bottom },
                  'middle': { 'anchor': COMPONENT_ID_RELATIVE_ICON, 'align': HorizontalAlign.Center }
                })
            }
            .height('auto')
          }
        })

        if (this.pinTopDialogVm!.isAllScroll) {
          GridItem() {
            this.buildActionButton();
          }
          .width('100%')
          .columnStart(0)
          .columnEnd(this.pinTopDialogVm!.colCount - 1);
        }
      }
      .columnsTemplate(this.gridColumnTemplate)
      .columnsGap($r('app.float.ntf_pin_top_app_col_gap'))
      .rowsGap($r('app.float.ntf_pin_top_app_row_gap'))
      .height(this.pinTopDialogVm!.scrollerHeight)
      .padding(this.pinTopDialogVm!.isAllScroll ? {
        left: $r('app.float.ntf_pin_top_app_dialog_content_padding'),
        right: $r('app.float.ntf_pin_top_app_dialog_content_padding')
      } :
        {
          top: $r('app.float.ntf_pin_top_grid_item_padding_top'),
          bottom: $r('app.float.ntf_pin_top_grid_item_padding_bottom'),
          left: $r('app.float.ntf_menu_dialog_text_padding'),
          right: $r('app.float.ntf_menu_dialog_text_padding')
        })
      .borderRadius(this.pinTopDialogVm!.isAllScroll ? $r('sys.float.corner_radius_level16') : 0)

      if (!this.pinTopDialogVm!.isAllScroll) {
        this.buildActionButton();
      }
    }
    .width('100%')
    .padding(this.pinTopDialogVm!.isAllScroll ? undefined : {
      left: $r('app.float.ntf_pin_top_app_dialog_content_padding'),
      right: $r('app.float.ntf_pin_top_app_dialog_content_padding')
    })
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
    .borderRadius($r('sys.float.corner_radius_level16'))
    .margin({
      left: $r('sys.float.ohos_id_dialog_margin_start'),
      right: $r('sys.float.ohos_id_dialog_margin_end')
    })
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      this.pinTopDialogVm?.refreshIsAllScroll(newValue?.height, COMPONENT_ID_CONTENT);
    })
  }

  @Builder
  buildTitleContent() {
    Text($r('app.string.ntf_pin_top_dialog_reach_limit_title'))
      .draggable(false)
      .id(COMPONENT_ID_REACH_LIMIT)
      .width('100%')
      .textAlign(TextAlign.Center)
      .fontWeight(FontWeight.Medium)
      .height(ResourceVm.instance.getFontSize($r('app.float.ntf_settings_dialog_title_height')))
      .fontSize($r('app.float.ntf_setting_pinned_limited_dialog_font_size'))
      .maxFontScale(ResourceVm.DEFAULT_MAX_SCALE)
      .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
      .fontWeight(FontWeight.Bold)
      .padding({
        left: $r('app.float.ntf_menu_dialog_text_padding'),
        right: $r('app.float.ntf_menu_dialog_text_padding')
      })
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(2)
  }

  @Builder
  buildDialogContent() {
    Text(this.pinTopDialogVm?.dialogContentText)
      .draggable(false)
      .id(COMPONENT_ID_CONTENT)
      .width('100%')
      .textAlign(TextAlign.Start)
      .fontSize($r('app.float.ntf_settings_dialog_content_font_size'))
      .maxFontScale(ResourceVm.DEFAULT_MAX_SCALE)
      .fontColor($r('sys.color.ohos_id_color_titlebar_text'))
      .lineHeight($r('app.float.ntf_settings_dialog_content_line_height_fp'))
      .fontWeight(FontWeight.Medium)
      .padding({
        left: $r('app.float.ntf_menu_dialog_text_padding'),
        right: $r('app.float.ntf_menu_dialog_text_padding')
      })
  }

  @Builder
  buildActionButton() {
    Row() {
      Button({ type: ButtonType.Capsule }) {
        Text($r('app.string.cancel'))
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .maxFontScale(ResourceVm.DEFAULT_MAX_SCALE)
          .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
          .fontWeight(FontWeight.Medium)
      }
      .height(ResourceVm.instance.getFontSize($r('app.float.ntf_setting_dialog_item_height')))
      .id(COMPONENT_ID_CANCEL)
      .backgroundColor(Color.Transparent)
      .layoutWeight(1)
      .onClick(() => {
        this.pinTopDialogVm?.onCancel();
      })

      Line()
        .width($r('app.float.ntf_pin_top_app_dialog_bottom_divider_width'))
        .height($r('app.float.ntf_pin_top_app_dialog_bottom_divider_height'))
        .backgroundColor($r('sys.color.ohos_id_color_list_separator'))
        .margin({
          left: $r('app.float.ntf_menu_dialog_button_margin'),
          right: $r('app.float.ntf_menu_dialog_button_margin')
        })
      Button({ type: ButtonType.Capsule }) {
        Text($r('app.string.confirm'))
          .fontSize($r('sys.float.ohos_id_text_size_button1'))
          .maxFontScale(ResourceVm.DEFAULT_MAX_SCALE)
          .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
          .fontWeight(FontWeight.Medium)
      }
      .height(ResourceVm.instance.getFontSize($r('app.float.ntf_setting_dialog_item_height')))
      .id(COMPONENT_ID_CONFIRM)
      .backgroundColor(Color.Transparent)
      .layoutWeight(1)
      .onClick(() => {
        this.pinTopDialogVm?.onSubmit(this.operationList);
      })
      .enabled(this.isEnable)
      .opacity(this.isEnable ? 1 : 0.6)
    }
    .margin({
      top: $r('app.float.ntf_settings_dialog_bottom_button_margin_top'),
      bottom: $r('app.float.ntf_pin_top_bottom_button_margin_bottom')
    })
    .alignItems(VerticalAlign.Center)
  }
}