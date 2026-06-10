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
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { SCBWindowSceneConfig, } from '@ohos/frameworkwrapper';
import {
  NeedRenderScale,
  NeedRenderRecentMinBackgroundSize,
  NeedRenderRecentMinBackgroundAlpha,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBScreenProperty,
  SCBWindowShadowConfig,
  NeedRenderAlpha,
  NeedRenderRecentCoverTranslate,
  SCBSceneSession
} from '@ohos/windowscene';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';

const TAG = 'SCBRecentMinBackgroundView';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

@Component
export struct SCBRecentMinBackgroundView {
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @ObjectLink needRenderAlpha: NeedRenderAlpha;
  @ObjectLink needRenderScale: NeedRenderScale;
  @ObjectLink needRenderRecentMinBackgroundSize: NeedRenderRecentMinBackgroundSize;
  @ObjectLink needRenderRecentMinBackgroundAlpha: NeedRenderRecentMinBackgroundAlpha;
  @ObjectLink needRenderRecentCoverTranslate: NeedRenderRecentCoverTranslate;
  @ObjectLink sceneSession: SCBSceneSession | null | undefined;
  @ObjectLink screenProperty: SCBScreenProperty;
  private shadowConfig: SCBWindowShadowConfig = new SCBWindowShadowConfig();

  private getWidth(): number {
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair) {
      return this.getSceneWidthForSplitPair();
    } else {
      return this.getSceneWidth();
    }
  }

  private getSceneWidth(): number {
    return this.needRenderRecentMinBackgroundSize.width;
  }

  private getSceneWidthForSplitPair(): number {
    if (!this.sceneSession) {
      return 0;
    }
    let sceneWidth = this.sceneSession.currRect.width.getVp() * this.needRenderScale.scaleX;
    return Math.max(sceneWidth, SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH);
  }

  private getHeight(): number {
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair) {
      return this.getSceneHeightForSplitPair();
    } else {
      return this.needRenderRecentMinBackgroundSize.height;
    }
  }

  private getSceneHeightForSplitPair(): number {
    if (!this.sceneSession) {
      return 0;
    }
    return this.sceneSession.currRect.height.getVp() * this.needRenderScale.scaleY;
  }

  private getPostionForRecent(): Position {
    if (!this.sceneContainerSession.primarySession) {
      return { x: 0, y: 0 };
    }
    return {
      x: this.needRenderRecentCoverTranslate.translateX,
      y: this.needRenderRecentCoverTranslate.translateY +
        SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2 +
      SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE
    };
  }

  private getPositionForSplitPair(): Position {
    if (!this.sceneSession) {
      return { x: 0, y: 0 };
    }

    let posX: number = 0;
    let posY: number = 0;
    const titleHeight = SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2 +
    SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE;
    const isUpDownSplit = this.sceneContainerSession.dividerParam.isExpandUpDownSplit();
    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      posX = this.needRenderRecentCoverTranslate.translateX;
      posY = this.needRenderRecentCoverTranslate.translateY + titleHeight;
    } else {
      posX = this.needRenderRecentCoverTranslate.secondaryTranslateX;
      posY = this.needRenderRecentCoverTranslate.secondaryTranslateY + (isUpDownSplit ? 0 : titleHeight);
    }
    return { x: posX, y: posY }
  }

  private getPosition(): Position {
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair) {
      return this.getPositionForSplitPair();
    } else {
      return this.getPostionForRecent();
    }
  }

  private getBorderRadius(): number {
    const floatCornerRadius: number = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    if (this.sceneContainerSession.needRenderScale.scaleX > 1) {
      return floatCornerRadius;
    }
    return floatCornerRadius * this.sceneContainerSession.needRenderScale.scaleX;
  }

  private initBackgroundShadow(): void {
    const windowSceneConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig;
    if (this.sceneContainerSession.primarySession && this.sceneContainerSession.primarySession.isFocused) {
      this.shadowConfig.radius = windowSceneConfig.focusedShadow.radius;
      this.shadowConfig.offsetX = windowSceneConfig.focusedShadow.offsetX;
      this.shadowConfig.offsetY = windowSceneConfig.focusedShadow.offsetY;
      this.shadowConfig.color = windowSceneConfig.focusedShadow.color;
    } else {
      this.shadowConfig.radius = windowSceneConfig.unfocusedShadow.radius;
      this.shadowConfig.offsetX = windowSceneConfig.unfocusedShadow.offsetX;
      this.shadowConfig.offsetY = windowSceneConfig.unfocusedShadow.offsetY;
      this.shadowConfig.color = windowSceneConfig.unfocusedShadow.color;
    }
    this.shadowConfig.radius *= this.needRenderScale.scaleX;
    this.shadowConfig.offsetX *= this.needRenderScale.scaleX;
    this.shadowConfig.offsetY *= this.needRenderScale.scaleY;
  }

  aboutToAppear(): void {
    this.initBackgroundShadow();
  }

  build() {
    Stack()
      .backgroundColor(SCBRecentStyleConstants.RECENT_BACKGROUND_COLOR_FOR_MIN_WIDTH)
      .borderRadius(this.getBorderRadius())
      .shadow({
        radius: this.shadowConfig.radius,
        color: this.shadowConfig.color,
        offsetX: this.shadowConfig.offsetX,
        offsetY: this.shadowConfig.offsetY
      })
      .width(this.getWidth())
      .height(this.getHeight())
      .position(this.getPosition())
      .opacity(this.needRenderRecentMinBackgroundAlpha.alpha)
  }
}