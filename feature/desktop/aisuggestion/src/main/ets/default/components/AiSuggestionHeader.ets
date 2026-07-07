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

import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import GridLayoutItemInfo from '@ohos/launchercommon/src/main/ets/bean/GridLayoutItemInfo';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { AiSuggestionLayoutStyle, LayoutComponentId } from '../config/AiSuggestionLayoutStyle';
import AiSuggestionActionManager from '../manager/AiSuggestionActionManager';

const TAG = 'AiSuggestionHeader';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

const TITLE_DEFAULT_HEIGHT: number = 34;

/**
 * 语音助手建议卡片头部组件
 *
 * @since 2024-06-21
 */
@Component
export struct AiSuggestionHeader {
  // 小球旋转时长
  private static readonly ROTATE_DURATION: number = 700;
  // 小球旋转角度
  private static readonly ROTATE_ANGLE: number = 360;
  private lastClickTime: number = 0;
  private touchDownTime: number = 0;
  private isLongPress: boolean = false;
  onItemSelected?: (index: number) => void;
  @Prop private title: string = '';
  @Prop private layoutStyle: AiSuggestionLayoutStyle;
  @Prop private titleClr: ResourceColor;
  @Prop @Watch('lineHeightChange') private lineHeight: number = TITLE_DEFAULT_HEIGHT;
  @Prop private zIndexGrid: number;
  @Prop private formItem: GridLayoutItemInfo;
  @Prop gridPadding: number;
  @State rotateAngle: number = 0;
  @Prop supportChange: boolean;
  @State rowHeight: number = TITLE_DEFAULT_HEIGHT;
  @Prop isPortfolioCard: boolean = false;
  @Prop itemOpacity: number = 1;
  private isOuterDesktop: boolean = false;
  private onTouchCallBack = (event: TouchEvent) => {
    if (event?.type === TouchType.Down) {
      this.touchDownTime = Date.now();
    } else if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
      this.onItemSelected?.(-1);
      this.isLongPress = (Date.now() - this.touchDownTime) >= 500;
    }
  }

  private onClickHotSpot(): void {
    if (editModeManager.isInEditMode()) {
      log.showInfo('onClickHotSpot isInEditMode');
      return;
    }
    if (this.isFastClick() || this.isLongPress) {
      log.showInfo('onClickHotSpot isFastClick or longPress');
      return;
    }
    this.onItemSelected?.(0);
    this.rotateAngle += AiSuggestionHeader.ROTATE_ANGLE;
    AiSuggestionActionManager.getInstance().clickHotSpot(this.formItem);
  }

  private isFastClick(): boolean {
    let curTime = Date.now();
    if (Math.abs(curTime - this.lastClickTime) <= 500) {
      return true;
    }
    this.lastClickTime = curTime;
    return false;
  }

  private lineHeightChange(): void {
    this.rowHeight = this.lineHeight;
  }

  private isEnable(): boolean {
    return this.supportChange && !this.isPortfolioCard;
  }

  aboutToAppear(): void {
    this.rowHeight = this.lineHeight;
  }

  private getRowHeight(): number {
    if (!this.rowHeight || this.rowHeight === 0) {
      return TITLE_DEFAULT_HEIGHT;
    }
    return this.rowHeight;
  }

  build() {
    Row() {
      Text(this.title)
        .fontSize(this.isOuterDesktop ? '10vp' : '14vp')
        .lineHeight(this.isOuterDesktop ? '14vp' : '18vp')
        .width(this.isEnable() ? '84%' : '100%')
        .fontColor(this.titleClr)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
      Blank()
        .height(StyleConstants.PERCENTAGE_100)
        .width(this.supportChange ? 5 : 0)
      Image($r('app.media.icon_change'))
        .draggable(false)
        .fillColor(this.titleClr)
        .height(this.isOuterDesktop ? 14 : 18)
        .width(this.isOuterDesktop ? 14 : 18)
        .rotate({ angle: this.rotateAngle })
        .visibility(this.isEnable() ? Visibility.Visible : Visibility.None)
        .animation({
          duration: AiSuggestionHeader.ROTATE_DURATION,
          curve: curves.cubicBezierCurve(0, 0, 0, 1),
          playMode: PlayMode.Alternate,
        })
    }
    .padding({ left: 12, top: 10, right: 12 })
    .width(StyleConstants.PERCENTAGE_100)
    .height(this.getRowHeight())
    .alignItems(VerticalAlign.Top)
    .visibility(this.gridPadding === 0 ? Visibility.None : Visibility.Visible)
    .alignRules(this.layoutStyle?.titleAlignRules())
    .id(LayoutComponentId.PORTFOLIO_TITLE)
    .zIndex(this.zIndexGrid)
    .enabled(this.isEnable())
    .opacity(this.itemOpacity)
    .onClick(() => this.onClickHotSpot())
    .onTouch(this.onTouchCallBack)
  }
}