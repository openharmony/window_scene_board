/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

import { StyleConstants } from '@ohos/launchercommon';
import {
  SCBSceneContainerSession,
  NeedRenderBackgroundAlpha,
  SCBSceneMode,
  SCBScreenProperty,
  NeedRenderScale,
  NeedRenderRecentCoverTranslate,
  SCBSceneSession
} from '@ohos/windowscene';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';
import { SCBRecentSessionsViewModel } from '../recentview/SCBRecentSessionsViewModel';
import { DividerStyle } from '@ohos/pcmode';
import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils/src/main/ets/TsIndex';


const TAG = 'SCBRecentHoverView';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);
/**
 * SCBRecentBackground
 */
@Component
export struct SCBRecentHoverView {
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @ObjectLink needRenderBackgroundAlpha: NeedRenderBackgroundAlpha;
  @ObjectLink needRenderScale: NeedRenderScale;
  @ObjectLink needRenderRecentCoverTranslate: NeedRenderRecentCoverTranslate;
  @ObjectLink sceneSession: SCBSceneSession | null | undefined;
  @ObjectLink screenProperty: SCBScreenProperty;
  @Prop singleContext?: SingleContext;

  /**
   * calculate the card radius linearly based on the maximum and minimum height of the card and the corresponding radius
   * borderRadius = (max_radius-min_radius)/(maxHeight-minHeight)*(nowHeight-minHeight)+min_radius
   * @returns number card radius
   */
  private getBorderRadius(): number {
    const floatCornerRadius: number = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    if (this.sceneContainerSession.needRenderScale.scaleX > 1) {
      return floatCornerRadius;
    }
    return floatCornerRadius * this.sceneContainerSession.needRenderScale.scaleX;
  }

  /**
   * get the outer card radius, which is 2 vp greater than the inner card radius
   * @returns number card radius
   */
  private getOuterBorderRadius(): number {
    return this.getBorderRadius() + SCBRecentStyleConstants.RECENT_IMAGE_OUTER_ADD_RADIUS;
  }

  private getOuterBorderWidth(): number {
    return this.sceneContainerSession.tabSelected
      ? SCBRecentStyleConstants.OUTER_BORDER_WIDTH : SCBRecentStyleConstants.BORDER_WIDTH;
  }

  private getInnerBorderWidth(): number {
    return this.sceneContainerSession.tabSelected
      ? SCBRecentStyleConstants.INNER_BORDER_WIDTH : SCBRecentStyleConstants.BORDER_WIDTH;
  }

  private getRecentPosition(): Position {
    if (!this.sceneContainerSession.primarySession) {
      return { x: 0, y: 0 };
    }
    return { x: this.needRenderRecentCoverTranslate.translateX -
      (SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE / 2 + SCBRecentStyleConstants.SESSION_OUTER_SIZE / 2),
      y: this.needRenderRecentCoverTranslate.translateY - SCBRecentStyleConstants.BORDER_WIDTH }
  }

  private getSplitRecentPositionForPair(): Position {
    if (!this.sceneSession) {
      return { x: 0, y: 0 };
    }
    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      return {
        x: this.needRenderRecentCoverTranslate.translateX - (SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE / 2 +
          SCBRecentStyleConstants.SESSION_OUTER_SIZE / 2),
        y: this.needRenderRecentCoverTranslate.translateY - SCBRecentStyleConstants.SESSION_OUTER_SIZE / 2
      }
    } else {
      if (this.sceneContainerSession.dividerParam.isExpandUpDownSplit()) {
        return {
          x: this.needRenderRecentCoverTranslate.translateX - (SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE / 2 +
            SCBRecentStyleConstants.SESSION_OUTER_SIZE / 2),
          y: this.needRenderRecentCoverTranslate.secondaryTranslateY - SCBRecentStyleConstants.SESSION_OUTER_SIZE / 2 -
            SCBRecentStyleConstants.HOVER_VIEW_PADDING
        };
      }
      return {
        x: this.needRenderRecentCoverTranslate.secondaryTranslateX -
          (SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE / 2 + SCBRecentStyleConstants.SESSION_OUTER_SIZE / 2),
        y: this.needRenderRecentCoverTranslate.translateY - SCBRecentStyleConstants.SESSION_OUTER_SIZE / 2
      };
    }
  }

  private getPosition(): Position {
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair) {
      return this.getSplitRecentPositionForPair();
    } else {
      return this.getRecentPosition();
    }
  }

  /**
   * get border color, the hover border is 1vp with double border, the focus border is 2 vp with single border
   * @param isInnerBorder whether or not the innerBorder
   * @returns border color
   */
  private getBorderColor(isInnerBorder: boolean): ResourceColor {
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair &&
      this.sceneContainerSession.secondarySession && !this.sceneContainerSession.dividerParam.isExpandUpDownSplit()) {
      if (this.sceneSession?.isSelected) {
        return SCBRecentStyleConstants.TAB_SELECTED_BORDER_COLOR;
      }
    } else {
      if (this.sceneContainerSession.tabSelected) {
        return SCBRecentStyleConstants.TAB_SELECTED_BORDER_COLOR;
      }
      if (this.sceneContainerSession.needRenderRecentHoverState.hoverState) {
        return isInnerBorder ? SCBRecentStyleConstants.INNER_BORDER_COLOR : SCBRecentStyleConstants.OUTER_BORDER_COLOR;
      }
    }
    return SCBRecentStyleConstants.RECENT_TRANSPARENT_COLOR;
  }

  private getBackgroundColor(): ResourceColor {
    if (this.sceneContainerSession.tabSelected) {
      return SCBRecentStyleConstants.TAB_SELECTED_CARD_BG_COLOR;
    }
    return this.sceneContainerSession.needRenderRecentHoverState.hoverState
      ? SCBRecentStyleConstants.HOVERED_BACKGROUND_COLOR : SCBRecentStyleConstants.SELECTED_BACKGROUND_COLOR;
  }

  private getSceneWidth(): number {
    if (!this.sceneContainerSession.primarySession) {
      return 0;
    }
    let sceneWidth: number =
      this.sceneContainerSession.primarySession?.currRect.width.getVp() * this.needRenderScale.scaleX;
    if (this.sceneContainerSession.isSplit && !this.sceneContainerSession.dividerParam.isExpandUpDownSplit()) {
      sceneWidth += DividerStyle.DIVIDER_WIDTH * this.needRenderScale.scaleX;
      sceneWidth += this.sceneContainerSession.secondarySession?.currRect.width.getVp() as number *
      this.needRenderScale.scaleX;
    }
    if (sceneWidth < SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH) {
      sceneWidth = SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH;
    }
    return sceneWidth;
  }

  private getSplitSceneWidthForPair(): number {
    if (!this.sceneSession) {
      return 0;
    }
    const scale: number = this.needRenderScale.scaleX;
    const sceneWidth: number =
      this.sceneSession.currRect.width.getVp() * scale < SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH ?
      SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH : this.sceneSession.currRect.width.getVp() * scale;
    return sceneWidth;
  }

  private getWidth(): number {
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair) {
      return this.getSplitSceneWidthForPair();
    } else {
      return this.getSceneWidth();
    }
  }

  private getSceneHeight(): number {
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair &&
    this.sceneContainerSession.dividerParam.isExpandUpDownSplit()) {
      return this.sceneSession?.currRect.height.getVp() as number * this.needRenderScale.scaleY;
    }

    let sceneHeight: number = this.sceneContainerSession.primarySession?.currRect.height.getVp() as number *
    this.needRenderScale.scaleY;
    if (this.sceneContainerSession.isSplit && this.sceneContainerSession.dividerParam.isExpandUpDownSplit()) {
      sceneHeight += DividerStyle.DIVIDER_WIDTH * this.needRenderScale.scaleY;
      sceneHeight += this.sceneContainerSession.secondarySession?.currRect.height.getVp() as number *
      this.needRenderScale.scaleY;
    }

    let minHeight = SCBRecentSessionsViewModel.getInstance(this.singleContext).getRecentCardMinHeight();
    return Math.max(minHeight, sceneHeight);
  }

  private getMarginHeight(): number {
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair &&
    this.sceneContainerSession.dividerParam.isExpandUpDownSplit()) {
      if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
        return SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2 +
        SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE + SCBRecentStyleConstants.HOVER_VIEW_PADDING;
      }
      if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
        return SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE / 2 + SCBRecentStyleConstants.HOVER_VIEW_PADDING;
      }
    }
    return SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2 +
    SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE +
      SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE / 2;
  }

  build() {
    Column() {
      Column() {
      }
      .height(this.getSceneHeight() + this.getMarginHeight())
      .width(this.getWidth() + SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE)
      .backgroundColor(this.getBackgroundColor())
      .borderRadius(this.getOuterBorderRadius() - SCBRecentStyleConstants.BORDER_WIDTH)
      .border({
        width: this.getInnerBorderWidth(),
        color: this.getBorderColor(true)
      })
      .focusable(false)
    }
    .height(this.getSceneHeight() + this.getMarginHeight() + SCBRecentStyleConstants.SESSION_OUTER_SIZE)
    .width(this.getWidth() + SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE +
      SCBRecentStyleConstants.SESSION_OUTER_SIZE)
    .position(this.getPosition())
    .borderRadius(this.getOuterBorderRadius())
    .opacity(this.needRenderBackgroundAlpha.backgroundAlpha)
    .border({
      width: this.getOuterBorderWidth(),
      color: this.getBorderColor(false)
    })
    .focusable(false)
    .visibility((this.sceneSession?.hoverState || this.sceneSession?.isSelected) ? Visibility.Visible : Visibility.None)
  }
}