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

import { GlassAppWhiteListManager } from './../../common/manager/GlassAppWhiteListManager';
import { GlassLayoutSize, NtfColor, NtfSize } from '../../common/constants/GlassLayoutConstants';
import NotificationConstant from '../common/NotificationConstant';
import { NotificationGlassVm, NotificationUtil } from '../vm/NotificationGlassVm';
import { NotificationGlassVmArray } from '../vm/NotificationVmItemArray';
import { GlassNotificationSingleItem } from './GlassNotificationSingleItem';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassTimeVM } from '../../common/utils/GlassTimeVM';
import { GlassNtfListVm } from '../vm/GlassNtfListVm';

const NORMAL_HEIGHT = '5.5px';
const EXPAND_HEIGHT = '54.5px';
const TAG = 'GlassNotificationGroupItem';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);
const NTF_EXPAND_NUM: number = 2;
const NTF_EXPAND_SHOW_NUM_LIMIT: number = 3;

/**
 * 通知分组
 */
@Component
export struct GlassNotificationGroupItem {
  /**
   * 分组通知数据
   * 分组通知对象一般不会变
   */
  @ObjectLink @Watch('onChildChange') notificationGlassVm: NotificationGlassVm | null;
  /**
   * 是否展开
   */
  @State isExpand: boolean = false;
  @State @Watch('update') childrenArr: NotificationGlassVmArray = new NotificationGlassVmArray();
  @State notificationGroupHeight: string = NORMAL_HEIGHT;
  @State notificationAppName: string = NotificationConstant.EMPTY_STRING;
  @State numberVisibility: Visibility = Visibility.Hidden;
  @State timeVM: GlassTimeVM = new GlassTimeVM();

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    if (this.notificationGlassVm) {
      this.childrenArr = this.notificationGlassVm.childrenArr;
      this.notificationAppName =
        GlassAppWhiteListManager.getInstance().getAppName(this.notificationGlassVm.creatorBundleName);
      this.timeVM.init(this.notificationGlassVm.deliveryTime, this.notificationGlassVm.hashCode);
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.timeVM.deinit();
  }

  onChildChange(): void {
    log.showInfo(`onChildChange,child num is ${this.notificationGlassVm?.getChildrenSize()}`);
    this.notificationGlassVm?.sortChildren();
  }

  @Builder
  buildNtfGroupBrief() {
    if (this.notificationGlassVm) {
      Row() {
        Row({ space: NotificationConstant.SPACE_20 }) {
          Image(this.notificationGlassVm.getAppIcon(true))
            .width(GlassLayoutSize.ICON_SIZE_66)
            .height(GlassLayoutSize.ICON_SIZE_66)
            .interpolation(ImageInterpolation.High)

          Column({ space: NotificationConstant.SPACE_12 }) {
            ForEach(this.childrenArr, (item: NotificationGlassVm, index: number) => {
              if (index < NTF_EXPAND_SHOW_NUM_LIMIT) {
                Row({ space: NotificationConstant.SPACE_12 }) {
                  if (NotificationUtil.isNtfAsRequired(item)) {
                    Text(item.notificationContent?.contentTitle)
                      .width(NotificationConstant.TITLE_SIZE_200)
                      .height(NotificationConstant.TITLE_SIZE_33)
                      .fontColor(NtfColor.NTF_TITLE_FONT_COLOR)
                      .fontSize(GlassLayoutSize.FONT_SIZE_28)
                      .fontWeight(NtfSize.NTF_CONTENT_FONT_WEIGHT)
                      .lineHeight(GlassLayoutSize.FONT_SIZE_33)
                      .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
                      .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
                      .maxLines(NotificationConstant.TITLE_MAX_LINE)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text(item.notificationContent?.contentText)
                      .width(NotificationConstant.NOTIFICATIONCONTENT_SIZE_550)
                      .height(NotificationConstant.NOTIFICATIONCONTENT_SIZE_33)
                      .fontColor(NtfColor.NTF_CONTENT_FONT_COLOR)
                      .fontSize(GlassLayoutSize.FONT_SIZE_28)
                      .lineHeight(GlassLayoutSize.FONT_SIZE_33)
                      .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
                      .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
                      .maxLines(NotificationConstant.COLLAPSE_CONTEXT_MAX_LINE)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  } else {
                    Text(this.notificationAppName)
                      .width(NotificationConstant.TITLE_SIZE_200)
                      .height(NotificationConstant.TITLE_SIZE_33)
                      .fontColor(NtfColor.NTF_TITLE_FONT_COLOR)
                      .fontSize(GlassLayoutSize.FONT_SIZE_28)
                      .fontWeight(GlassLayoutSize.FONT_WEIGHT_700)
                      .lineHeight(GlassLayoutSize.FONT_SIZE_33)
                      .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
                      .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
                      .maxLines(NotificationConstant.TITLE_MAX_LINE)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Text($r('app.string.banner_hint_message'))
                      .width(NotificationConstant.NOTIFICATIONCONTENT_SIZE_550)
                      .height(NotificationConstant.NOTIFICATIONCONTENT_SIZE_33)
                      .fontColor(NtfColor.NTF_CONTENT_FONT_COLOR)
                      .fontSize(GlassLayoutSize.FONT_SIZE_28)
                      .lineHeight(GlassLayoutSize.FONT_SIZE_33)
                      .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
                      .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
                      .maxLines(NotificationConstant.COLLAPSE_CONTEXT_MAX_LINE)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                }
              }
            }, (item: NotificationGlassVm, index: number) => item.getListKey() + index)
          }
        }

        Column({ space: this.notificationGroupHeight }) {
          Text(this.timeVM.timeText)
            .height(NotificationConstant.TIME_SIZE_28)
            .fontColor(NtfColor.NTF_TIME_FONT_COLOR)
            .fontSize(GlassLayoutSize.FONT_SIZE_24)
            .lineHeight(GlassLayoutSize.FONT_SIZE_28)
            .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
            .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
            .textAlign(TextAlign.End)

          Row() {
            Text(`+${this.childrenArr.length - NTF_EXPAND_SHOW_NUM_LIMIT}`)
              .height(NotificationConstant.TIME_SIZE_28)
              .fontColor(NtfColor.NTF_COLLAPSE_NUM_COLOR)
              .fontSize(GlassLayoutSize.FONT_SIZE_24)
              .fontWeight(GlassLayoutSize.FONT_WEIGHT_500)
              .lineHeight(GlassLayoutSize.FONT_SIZE_28)
              .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
              .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
              .textAlign(TextAlign.End)
              .onClick(() => {
                this.isExpand = !this.isExpand;
              })
              .visibility(this.numberVisibility)
          }
          .size({
            width: NtfSize.NTF_COLLAPSE_NUM_BUTTON_WIDTH,
            height: NtfSize.NTF_COLLAPSE_NUM_BUTTON_HEIGHT
          })
          .borderRadius(NtfSize.NTF_COLLAPSE_NUM_BUTTON_BORDER_RADIUS)
          .backgroundColor(NtfColor.NTF_COLLAPSE_NUM_BG_COLOR)
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .visibility(this.numberVisibility)
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.End)
      }
      .borderRadius(NotificationConstant.BORDERRADIUS_32)
      .backgroundColor(NtfColor.NTF_BACKGROUND_COLOR)
      .width(NotificationConstant.SINGLE_ITEM_WIDTH)
      .padding(NotificationConstant.NTF_PADDING_24)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        this.isExpand = !this.isExpand;
      })
    }
  }

  @Builder
  buildNtfGroupDetai() {
    Column() {
      Row() {
        Row({ space: NotificationConstant.SPACE_24 }) {
          Image(this.notificationGlassVm?.getAppIcon(true))
            .width(NtfSize.HINT_CALL_APP_SIZE)
            .height(NtfSize.HINT_CALL_APP_SIZE)
            .interpolation(ImageInterpolation.High)

          Text(this.notificationAppName)
            .width(NotificationConstant.TITLE_SIZE_200)
            .height(NotificationConstant.TITLE_SIZE_28)
            .fontColor(NtfColor.NTF_TITLE_FONT_COLOR)
            .fontSize(GlassLayoutSize.FONT_SIZE_24)
            .lineHeight(GlassLayoutSize.FONT_SIZE_28)
            .fontWeight(GlassLayoutSize.FONT_WEIGHT_700)
            .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
            .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
            .maxLines(NotificationConstant.TITLE_MAX_LINE)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }

        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.glass_nfscenter_up'))
            .width(GlassLayoutSize.NTF_EXPAND_ICON_WIDTH)
            .height(GlassLayoutSize.NTF_EXPAND_ICON_HEIGHT)
            .fillColor(NtfColor.NTF_EXPAND_ICON_COLOR)
            .interpolation(ImageInterpolation.High)
        }
        .width(GlassLayoutSize.NTF_EXPAND_ICON_BG_SIZE)
        .height(GlassLayoutSize.NTF_EXPAND_ICON_BG_SIZE)
        .borderRadius(NotificationConstant.BORDERRADIUS_100)
        .backgroundColor(NtfColor.NTF_EXPAND_ICON_BG_COLOR)
        .onClick(() => {
          this.isExpand = !this.isExpand;
        })
      }
      .backgroundColor(NtfColor.NTF_BACKGROUND_COLOR)
      .width(NotificationConstant.SINGLE_ITEM_WIDTH)
      .border({
        radius: { topLeft: NotificationConstant.BORDERRADIUS_32, topRight: NotificationConstant.BORDERRADIUS_32 }
      })
      .padding(NotificationConstant.NTF_PADDING_24)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        this.isExpand = !this.isExpand;
      })

      List() {
        ForEach(this.childrenArr, (item: NotificationGlassVm, index: number) => {
          if (this.notificationGlassVm) {
            ListItem() {
              GlassNotificationSingleItem({
                notificationGlassVm: item,
                glassBorderRadius: NotificationConstant.BORDERRADIUS_0,
                isInGroup: true
              })
            }
            .transition({ type: TransitionType.Delete, opacity: 0 })
            .border({ width: { top: '1px' }, color: { top: NtfColor.NTF_DIVIDER_COLOR } })
            .height('auto')
            .swipeAction({
              end: {
                builder: () => {
                  this.itemEnd(item);
                },
                onAction: () => {
                  animateTo({ duration: 60 }, () => {
                    log.showInfo(`SwipeAction to remove ntf ${item.hashCode}`);
                    GlassNtfListVm.getInstance().clearByGlass(item);
                  })
                }, actionAreaDistance: 60
              }
            })
          }
        }, (item: NotificationGlassVm, index: number) => item.getListKey() + index)
      }
      .width(NotificationConstant.SINGLE_ITEM_WIDTH)
      .height('auto')
      .scrollBar(BarState.Off)
    }
    .alignItems(HorizontalAlign.Start)
    .borderRadius(NotificationConstant.BORDERRADIUS_32)
    .clip(true)
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      const hiddenRatio: number = 0;
      if (currentRatio === hiddenRatio) {
        this.isExpand = false;
      }
    })
  }

  @Builder
  itemEnd(notificationGlassVm: NotificationGlassVm) {
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.glass_nfscenter_delete'))
        .width(NtfSize.CLEAR_BG_SIZE)
        .height(NtfSize.CLEAR_BG_SIZE)
    }
    .width(NtfSize.CLEAR_BG_SIZE)
    .height(NtfSize.CLEAR_BG_SIZE)
    .margin({ left: NotificationConstant.NTF_MARGIN_47 })
    .backgroundColor(NtfColor.NTF_CLEAR_BUTTON_COLOR)
    .borderRadius(NotificationConstant.BORDERRADIUS_100)
    .onClick(() => {
      log.showInfo(`Click deleteButton to remove ntf ${notificationGlassVm.hashCode}`);
      GlassNtfListVm.getInstance().clearByGlass(notificationGlassVm);
    })
  }

  build() {
    if (this.isExpand) {
      this.buildNtfGroupDetai();
    } else {
      this.buildNtfGroupBrief();
    }
  }

  private update() {
    log.showInfo(`update child num is ${this.childrenArr.length}`);
    if (this.childrenArr.length > NTF_EXPAND_NUM) {
      this.notificationGroupHeight = EXPAND_HEIGHT;
    } else {
      this.notificationGroupHeight = NORMAL_HEIGHT;
    }
    if (this.childrenArr.length > NTF_EXPAND_SHOW_NUM_LIMIT) {
      this.numberVisibility = Visibility.Visible;
    } else {
      this.numberVisibility = Visibility.Hidden;
    }
  }
}
