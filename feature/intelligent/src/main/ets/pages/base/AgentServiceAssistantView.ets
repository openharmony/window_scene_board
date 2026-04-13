/*
 *
 *  Copyright (c) 2025 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

import { LengthMetrics } from '@ohos.arkui.node';
import {
  BuildOptions,
  DataModel,
  RegisterOptions
} from '@oh-flexiblelayout/flexiblelayout';
import { feedbackLogger as log } from '../../util/FeedBackLogUtil';
import {
  AgentServiceAssistantController,
  AgentServiceAssistantSwitch
} from '../../controller/AgentServiceAssistantController';
import {
  ASACard,
  ASACardChip,
  ASACardGuide
} from '../../common/bean/AgentServiceInfo';
import { AgentServiceAssistantCardData } from '../../card/AgentServiceAssistantCard/AgentServiceAssistantCardData';
import { StyleConstants } from '../../common/constants/StyleConstants';
import { HaModule } from '../../common/constants/HaReportConstants';
import { CommonContants } from '../../common/constants/CommonContants';
import { fontSizeScaleUtils } from '../../util/FontSizeScaleUtils';
import intelligentCompatibilityChecker from '../../controller/IntelligentCompatibilityChecker';
import { StateMachineCardMenu } from '../component/StateMachineCardMenu';
import { CardStackUtil } from '../component/cardStack/CardStackUtil';
import { adaptorUtil } from '../../util/AdaptorUtil';
import { CommonUtil } from '../../util/CommonUtil';

const TAG: string = 'AgentServiceAssistantView';

const AGENT_SERVICE_ASSISTANT_ID: string = 'agentServiceAssistantId';
const LONG_PRESS_TIME: number = 600;
const GUIDES_SWIPE_TIME_INTERVAL: number = 3000 // 3s

@Component
export struct AgentServiceAssistantView {
  @StorageProp('pagePaddingWidth') pagePaddingWidth: number =
    AppStorage.get('pagePaddingWidth') || StyleConstants.AUX_PAGE_PADDING_WIDTH;
  @StorageLink(AgentServiceAssistantSwitch.GENERAL_SWITCH) serviceAssistantSwitchStatus: boolean = true;
  @State refreshTime: number = 1;
  @State asaCard: ASACard | undefined = undefined;
  @State isMenuOpen: boolean = false;
  @State appIsBottomHalfOfTheScreen: boolean = true; //底部坐标是否超过屏幕高度一半
  @State menuClickState: number = 4;
  @State exposeGuide: string | undefined = undefined;

  public exposeGuideIndex: number = 0;
  private controller: AgentServiceAssistantController = AgentServiceAssistantController.getInstance();
  private cardData: AgentServiceAssistantCardData | null = null;

  /**
   * 生命周期回调。
   */
  async aboutToAppear() {
    log.showInfo(TAG, `aboutToAppear`);
    await this.controller.onViewAboutToAppear(this);
  }

  /**
   * 获取绑定菜单信息。
   * @returns
   */
  private getMenuInfo(): ContextMenuOptions {
    const positionInfo: ContextMenuOptions = {
      preview: MenuPreviewMode.IMAGE,
      placement: this.appIsBottomHalfOfTheScreen ? Placement.TopLeft : Placement.BottomLeft,
      aboutToAppear: () => {
        log.showInfo(TAG, 'getMenuInfo start');
        CardStackUtil.playVibration();
        this.isMenuOpen = true;
      },
      previewAnimationOptions: {
        scale: [1.0, 1.0]
      },
      onDisappear: () => {
        this.isMenuOpen = false;
      },
    }
    return positionInfo;
  }

  @Builder
  Title() {
    Row() {
      Text(this.asaCard?.display?.mainTitle ?? '')
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Bold)
        .fontSize(fontSizeScaleUtils.getRegularSize(this.cardData?.displayCss?.titleFontSize || 16))
        .lineHeight(fontSizeScaleUtils.getRegularSize(this.cardData?.displayCss?.titleLineHeight || 21))
        .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN)
    }
    .alignSelf(ItemAlign.Start)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .margin({
      top: LengthMetrics.vp(this.cardData?.displayCss?.marginTop || 0),
      bottom: LengthMetrics.vp(this.cardData?.displayCss?.marginBottom || 0),
    })
    .linearGradient({
      direction: GradientDirection.Right,
      colors: [
        [$r('app.color.service_assistant_title_start_color'), 0.0],
        [$r('app.color.service_assistant_title_end_color'), 1.0],
      ]
    })
    .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
  }

  @Builder
  Guides() {
    Row() {
      Row() {
        Row() {
          Text(this.exposeGuide ?? '')
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Medium)
            .fontSize(fontSizeScaleUtils.getRegularSize(this.cardData?.guidesCss?.textFontSize || 14))
            .textAlign(TextAlign.Start)
            .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
        }
        .width('100%')
        .height(this.cardData?.guidesCss?.textFontSize || 14)
        .linearGradient({
          angle: 160,
          colors: [
            [$r('app.color.service_assistant_guide_font_start_color'), 0.0],
            [$r('app.color.service_assistant_guide_font_middle_color'), 0.3],
            [$r('app.color.service_assistant_guide_font_end_color'), 1.0],
          ]
        })
        .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
      }
      .width('100%')
      .height(this.cardData?.guidesCss?.guideHeight || 40)
      .borderRadius(this.cardData?.guidesCss?.guideBorderRadius || 20)
      .padding({
        start: LengthMetrics.vp(this.cardData?.guidesCss?.guidePaddingStart || 10),
        end: LengthMetrics.vp(this.cardData?.guidesCss?.guidePaddingEnd || 10),
      })
      .linearGradient({
        angle: 90,
        colors: [
          [$r('app.color.service_assistant_guide_bg_start_color'), 0.0],
          [$r('app.color.service_assistant_guide_bg_end_color'), 1.0],
        ]
      })
      .onClick(() => {
        if (this.asaCard && this.asaCard?.guides && this.exposeGuideIndex < this.asaCard.guides.length) {
          let guide = this.asaCard.guides[this.exposeGuideIndex];
          log.showInfo(TAG, `click guide, name: ${guide.name}, type: ${guide.type}`);
          this.controller.onFuncElementClick(guide);
        }
      })
    }
    .width('100%')
    .margin({
      top: LengthMetrics.vp(this.cardData?.guidesCss?.lineMarginTop || 18),
      bottom: LengthMetrics.vp(this.cardData?.guidesCss?.lineMarginBottom || 0),
    })
    .padding({
      start: LengthMetrics.vp(this.cardData?.guidesCss?.linePaddingStart || 0),
      end: LengthMetrics.vp(this.cardData?.guidesCss?.linePaddingEnd || 0),
    })
  }

  @Builder
  Chips() {
    Row() {
      ForEach(this.asaCard?.chips ?? [], (chip: ASACardChip) => {
        Row() {
          Text(chip?.name ?? '')
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Regular)
            .fontSize(fontSizeScaleUtils.getRegularSize(this.cardData?.chipsCss?.textFontSize || 12))
            .fontColor($r('app.color.service_assistant_chip_font_color'))
            .lineHeight(fontSizeScaleUtils.getRegularSize(this.cardData?.chipsCss?.textLineHeight || 16))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .borderRadius(20)
        .backgroundColor($r('app.color.service_assistant_chip_bg_color'))
        .padding({
          top: LengthMetrics.vp(this.cardData?.chipsCss?.chipPaddingTop || 4),
          bottom: LengthMetrics.vp(this.cardData?.chipsCss?.chipPaddingBottom || 4),
          start: LengthMetrics.vp(this.cardData?.chipsCss?.chipPaddingStart || 8),
          end: LengthMetrics.vp(this.cardData?.chipsCss?.chipPaddingEnd || 8),
        })
        .margin({
          end: LengthMetrics.vp(this.cardData?.chipsCss?.chipMarginEnd || 8)
        })
        .onClick(() => {
          log.showInfo(TAG, `click chip, id: ${chip.chipId}, name: ${chip.name}, type: ${chip.type}`);
          this.controller.onFuncElementClick(chip);
        })
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
    .margin({
      top: LengthMetrics.vp(this.cardData?.chipsCss?.lineMarginTop || 12),
      bottom: LengthMetrics.vp(this.cardData?.chipsCss?.lineMarginBottom || 0),
    })
  }

  @Builder
  AgentCard() {
    Column() {
      this.Title();

      this.Guides();

      this.Chips();
    }
    .backgroundColor($r('app.color.service_assistant_background'))
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .borderRadius(20)
    .width('100%')
    .padding({
      top: LengthMetrics.vp(this.cardData?.cardViewCss?.paddingTop || 32),
      bottom: LengthMetrics.vp(this.cardData?.cardViewCss?.paddingBottom || 20),
      start: LengthMetrics.vp(this.cardData?.cardViewCss?.paddingStart || 12),
      end: LengthMetrics.vp(this.cardData?.cardViewCss?.paddingEnd || 12),
    })
    .id(AGENT_SERVICE_ASSISTANT_ID)
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        LongPressGesture({ repeat: false, duration: LONG_PRESS_TIME })
          .onAction(() => {
            let isOpen: boolean = intelligentCompatibilityChecker.isShowCloseAndPlaceholder();
            log.showInfo(TAG, `isMenuOpen: ${isOpen}`);
            if (isOpen) {
              adaptorUtil.scrollDownForAvoidHeader(AGENT_SERVICE_ASSISTANT_ID);
            }
          }),
      )
    )
    .bindContextMenu(this.MenuBuilder(), ResponseType.LongPress,
      intelligentCompatibilityChecker.isShowCloseAndPlaceholder() ? this.getMenuInfo() : {})
  }

  @Builder
  MenuBuilder() {
    if (intelligentCompatibilityChecker.isShowCloseAndPlaceholder()) {
      StateMachineCardMenu({
        menuClickState: this.menuClickState,
        isShowCloseButton: intelligentCompatibilityChecker.isShowCloseAndPlaceholder(),
        switchName: CommonContants.SERVICE_ASSISTANT_SWITCH,
        placement: this.appIsBottomHalfOfTheScreen ? Placement.TopLeft : Placement.BottomLeft,
        module: HaModule.SERVICES,
      })
        .width(224)
    }
  }

  build() {
    if (this.asaCard && this.serviceAssistantSwitchStatus) {
      Column() {
        this.AgentCard();
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .margin({
        top: LengthMetrics.vp(this.cardData?.cardViewCss?.marginTop || 12),
        bottom: LengthMetrics.vp(this.cardData?.cardViewCss?.marginBottom || 0),
      })
      .padding({
        start: LengthMetrics.vp(this.pagePaddingWidth),
        end: LengthMetrics.vp(this.pagePaddingWidth),
      })
    }
  }

  @Builder
  static cardBuilder(options: BuildOptions<AgentServiceAssistantCardData>) {
    AgentServiceAssistantView({
      cardData: options.data
    });
  }
}

export const serviceAssistantCardBuilder: RegisterOptions<AgentServiceAssistantCardData> = {
  name: 'grid.card.sceneboard.serviceassistant', // 必选参数：卡片名称，云端下发的布局数据中通过这里定义的名称引用
  builder: AgentServiceAssistantView.cardBuilder, // 必选参数：卡片构建方法
  dataBuilder: (data: DataModel): AgentServiceAssistantCardData => new AgentServiceAssistantCardData(data)
}