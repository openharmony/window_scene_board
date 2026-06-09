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

import wantAgentController, { WantAgent } from '@ohos.app.ability.wantAgent';
import { BusinessError } from '@kit.BasicServicesKit';
import { GlassSceneManager } from '../../scene/common/GlassSceneManager';
import { GlassAppWhiteListManager } from '../../common/manager/GlassAppWhiteListManager';
import { GlassLayoutSize, NtfColor, NtfSize, NtfToastCommon } from '../../common/constants/GlassLayoutConstants';
import { GlassShowToastOptions, GlassToastManager } from '../../toast/manager/GlassToastManager';
import NotificationConstant from '../common/NotificationConstant';
import { NotificationGlassVm, NotificationUtil, NotificationAction } from '../vm/NotificationGlassVm';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { wantAgent } from '@kit.AbilityKit';
import { GlassTimeVM } from '../../common/utils/GlassTimeVM';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';
import { GlassNtfListVm } from '../vm/GlassNtfListVm';

const NORMAL_HEIGHT = '122px';
const EXPAND_HEIGHT = '265px';

const TAG: string = 'Ntf-GlassNotificationActionButtonCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct GlassNotificationActionButtonCard {
  private isInGroup: boolean = false;
  @ObjectLink notificationGlassVm: NotificationGlassVm;
  @Prop glassBorderRadius: string;
  @State @Watch('updateHeight') isActionButtonsSee: boolean = false;
  @State notificationHeight: string = NORMAL_HEIGHT;
  @State timeVM: GlassTimeVM = new GlassTimeVM();

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.initTimeText();
  }

  private initTimeText(): void {
    if (this.notificationGlassVm) {
      this.timeVM.init(this.notificationGlassVm?.deliveryTime, this.notificationGlassVm?.hashCode);
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.timeVM.deinit();
  }

  @Builder
  buildNtfAppIcon() {
    Image(this.notificationGlassVm?.getAppIcon(true))
      .width(GlassLayoutSize.ICON_SIZE_66)
      .height(GlassLayoutSize.ICON_SIZE_66)
      .interpolation(ImageInterpolation.High)
  }

  @Builder
  buildNtfContent() {
    if (this.notificationGlassVm) {
      Row({ space: NotificationConstant.SPACE_20 }) {
        Image(this.notificationGlassVm.getAppIcon(true))
          .width(GlassLayoutSize.ICON_SIZE_66)
          .height(GlassLayoutSize.ICON_SIZE_66)
          .interpolation(ImageInterpolation.High)

        Column({ space: NotificationConstant.SPACE_8 }) {
          Row() {
            Text(this.notificationGlassVm.notificationContent.contentTitle)
              .width(NotificationConstant.TITLE_SIZE_200)
              .height(NotificationConstant.TITLE_SIZE_33)
              .fontColor(NtfColor.NTF_TITLE_FONT_COLOR)
              .fontSize(GlassLayoutSize.FONT_SIZE_28)
              .lineHeight(GlassLayoutSize.FONT_SIZE_33)
              .fontWeight(NtfSize.NTF_CONTENT_FONT_WEIGHT)
              .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
              .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
              .maxLines(NotificationConstant.TITLE_MAX_LINE)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(this.timeVM.timeText)
              .height(NotificationConstant.TIME_SIZE_28)
              .fontColor(NtfColor.NTF_TIME_FONT_COLOR)
              .fontSize(GlassLayoutSize.FONT_SIZE_24)
              .lineHeight(GlassLayoutSize.FONT_SIZE_28)
              .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
              .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
              .textAlign(TextAlign.End)
          }
          .width(NotificationConstant.NTF_WIDTH_988)
          .height(NtfSize.NTF_SINGLE_ITEM_HEIGHT)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)

          Row() {
            Text(this.notificationGlassVm.notificationContent.contentText)
              .width(NotificationConstant.NOTIFICATIONCONTENT_SIZE_888)
              .height(NotificationConstant.NOTIFICATIONCONTENT_SIZE_33)
              .fontColor(NtfColor.NTF_CONTENT_FONT_COLOR)
              .fontSize(GlassLayoutSize.FONT_SIZE_28)
              .lineHeight(GlassLayoutSize.FONT_SIZE_33)
              .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
              .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
              .maxLines(NotificationConstant.COLLAPSE_CONTEXT_MAX_LINE)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Button({ type: ButtonType.Circle }) {
              Image($r('app.media.glass_nfscenter_down'))
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
              this.isActionButtonsSee = true;
            })
          }
          .width(NotificationConstant.NTF_WIDTH_988)
          .height(NtfSize.NTF_SINGLE_ITEM_HEIGHT)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
        }
        .layoutWeight(1)
      }
      .borderRadius(this.glassBorderRadius)
      .backgroundColor(NtfColor.NTF_BACKGROUND_COLOR)
      .width(NotificationConstant.SINGLE_ITEM_WIDTH)
      .height(NotificationConstant.NTF_HEIGHT_122)
      .padding(NotificationConstant.NTF_PADDING_24)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        this.isActionButtonsSee = true;
      })
    }
  }

  @Builder
  buildNtfExpandContent() {
    if (this.notificationGlassVm) {
      Column() {
        Row() {
          Text(this.notificationGlassVm.notificationContent.expandedTitle)
            .fontColor(NtfColor.NTF_TITLE_FONT_COLOR)
            .fontSize(GlassLayoutSize.FONT_SIZE_28)
            .fontWeight(NtfSize.NTF_CONTENT_FONT_WEIGHT)
            .lineHeight(GlassLayoutSize.FONT_SIZE_33)
            .margin({ top: NotificationConstant.NTF_MARGIN_3 })
            .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
            .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
            .maxLines(NotificationConstant.TITLE_MAX_LINE)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .ellipsisMode(EllipsisMode.END)
          Text(this.timeVM.timeText)
            .height(NotificationConstant.TIME_SIZE_28)
            .fontColor(NtfColor.NTF_TIME_FONT_COLOR)
            .fontSize(GlassLayoutSize.FONT_SIZE_24)
            .lineHeight(GlassLayoutSize.FONT_SIZE_28)
            .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
            .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
            .textAlign(TextAlign.End)
        }
        .width(NotificationConstant.NTF_WIDTH_988)
        .justifyContent(FlexAlign.SpaceBetween)

        Text(this.notificationGlassVm.notificationContent.expandedContentText)
          .fontColor(NtfColor.NTF_CONTENT_FONT_COLOR)
          .fontSize(GlassLayoutSize.FONT_SIZE_28)
          .lineHeight(GlassLayoutSize.FONT_SIZE_33)
          .letterSpacing(GlassLayoutSize.LETTERSPACING_SIZE_0)
          .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
          .margin({ top: NotificationConstant.NTF_MARGIN_9 })
          .maxLines(NotificationConstant.EXPAND_CONTENT_MAX_LINE)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .ellipsisMode(EllipsisMode.END)
          .width(NotificationConstant.NTF_WIDTH_988)
      }
      .width(NotificationConstant.NTF_WIDTH_988)
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
  }

  @Builder
  buildNtfFolds() {
    Button({ type: ButtonType.Circle, stateEffect: true }) {
      Image($r('app.media.glass_banner_arrow_up'))
        .width(GlassLayoutSize.NTF_EXPAND_ICON_WIDTH)
        .height(GlassLayoutSize.NTF_EXPAND_ICON_HEIGHT)
        .fillColor(NtfColor.NTF_EXPAND_ICON_COLOR)
    }
    .width(GlassLayoutSize.NTF_EXPAND_ICON_BG_SIZE)
    .height(GlassLayoutSize.NTF_EXPAND_ICON_BG_SIZE)
    .backgroundColor(NtfColor.NTF_EXPAND_ICON_BG_COLOR)
    .onClick(() => {
      this.isActionButtonsSee = false;
    })
  }

  @Builder
  GlassNtfActionView() {
    if (this.notificationGlassVm) {
      Row({ space: NtfSize.NTF_BUTTON_DISTANCE }) {
        ForEach(this.notificationGlassVm.actionButtons,
          (action: NotificationAction, index: number) => {
            NotificationActionComponent({
              actionStr: action.actionTitle,
              onClickEvent: () => {
                this.onClickListener(index)
              },
            })
          }, (action: NotificationAction) => `${action.actionTitle}`)
      }
      .justifyContent(FlexAlign.Start)
      .margin({ right: NotificationConstant.NTF_MARGIN_688 })
    }
  }

  build() {
    if (this.notificationGlassVm) {
      if (this.isActionButtonsSee) {
        Column() {
          Row({ space: NotificationConstant.SPACE_20 }) {
            this.buildNtfAppIcon()
            Column() {
              this.buildNtfExpandContent()
              Row() {
                this.GlassNtfActionView()
                this.buildNtfFolds()
              }
              .margin({ top: NotificationConstant.NTF_MARGIN_47 })
              .justifyContent(FlexAlign.SpaceBetween)
              .width(NotificationConstant.NTF_WIDTH_988)
            }
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .onClick(() => {
            log.showInfo(`click to handle ntf ${this.notificationGlassVm.hashCode}`);
            NotificationUtil.clickNft(this.notificationGlassVm);
          })
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .layoutWeight(1)
        }
        .width('100%')
        .height(this.notificationHeight)
        .backgroundColor(NtfColor.NTF_BACKGROUND_COLOR)
        .borderRadius(this.isInGroup ? NtfSize.NTF_GROUP_ITEM_BORDER_RADIUS : NotificationConstant.BORDERRADIUS_32)
        .padding({
          left: NotificationConstant.NTF_PADDING_24,
          right: NotificationConstant.NTF_PADDING_24,
          top: NotificationConstant.NTF_PADDING_24,
          bottom: NotificationConstant.NTF_PADDING_24
        })
        .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
          const hiddenRatio: number = 0;
          if (currentRatio === hiddenRatio) {
            this.isActionButtonsSee = false;
          }
        })
      } else {
        this.buildNtfContent();
      }
    }
  }

  private updateHeight() {
    if (this.isActionButtonsSee) {
      this.notificationHeight = EXPAND_HEIGHT;
    } else {
      this.notificationHeight = NORMAL_HEIGHT;
    }
  }

  /**
   * 详情页actionButton的点击事件
   *
   * @param index actionButton对应的下标
   */
  private onClickListener(index: number): void {
    if (this.notificationGlassVm) {
      if (index < 0 || index >= this.notificationGlassVm.actionButtons.length) {
        log.showWarn('onClickListener,array index invalid');
        return;
      }
      log.showInfo(`onClickListener,ntf hashcode is ${this.notificationGlassVm.hashCode}`);
      const agent: WantAgent | undefined = this.notificationGlassVm.actionButtons[index]?.wantAgent;
      if (agent === undefined) {
        log.showWarn(`onClickListener handle cancel,agent is invalid`);
        return;
      }
      wantAgentController.getOperationType(agent).then((type: number) => {
        if (type !== wantAgentController.OperationType.SEND_COMMON_EVENT) {
          let isWhiteListApp: boolean =
            GlassAppWhiteListManager.getInstance().isWhiteListApp(this.notificationGlassVm.creatorBundleName);
          log.showInfo(`onClickListener,isWhiteListApp ${isWhiteListApp}`);
          if (!isWhiteListApp) {
            let options: GlassShowToastOptions = {
              message: NtfToastCommon.CAN_NOT_OPEN_MSG,
              bottom: NtfToastCommon.TOAST_BOTTOM,
              duration: NtfToastCommon.TOAST_DURATION,
              width: NtfToastCommon.CAN_NOT_OPEN_MSG_WID
            }
            GlassToastManager.getInstance().showToast(options);
            return;
          }
          GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_NOTIFICATION_CENTER);
          GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_STATUS_BAR);
        }
        wantAgent.trigger(agent,
          { code: 0, startOptions: { displayId: GlassSceneManager.getInstance().getScreenId() } },
          (error?: BusinessError) => {
            if (error) {
              log.showError('action button click,failed');
            } else {
              log.showInfo('action button click,success');
            }
          });
        if (this.notificationGlassVm.isAutoDelete) {
          log.showInfo(`onClickListener,ntf is AutoDelete`);
          GlassNtfListVm.getInstance().clearByGlass(this.notificationGlassVm);
        }
      })
    }
  }
}

/**
 * action按钮
 */
@Component
struct NotificationActionComponent {
  private actionStr?: string;

  build() {
    Stack() {
      Text(this.actionStr)
        .fontSize(GlassLayoutSize.FONT_SIZE_24)
        .fontWeight(GlassLayoutSize.FONT_WEIGHT_700)
        .fontColor(NtfColor.NTF_BUTTON_FONT_COLOR)
        .lineHeight(GlassLayoutSize.FONT_SIZE_28)
        .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
    }
    .onClick(this.onClickEvent)
    .height(NtfSize.NTF_SINGLE_ITEM_HEIGHT)
  }

  private onClickEvent: (() => void) = () => {
  };
}