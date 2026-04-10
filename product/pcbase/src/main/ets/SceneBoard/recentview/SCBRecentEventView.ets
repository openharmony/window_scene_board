/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, SingleContext, } from '@ohos/basicutils';
import {
  SCBSceneMode,
  SCBSceneContainerSession,
  SCBSceneSession,
  NeedRenderRecentCoverTranslate,
  SCBSceneSessionManager,
  SCBGestureAction,
  SCBGestureActionId,
  SCBScreenProperty,
  NeedRenderScale
} from '@ohos/windowscene';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';
import { SCBRecentSessionsViewModel } from './SCBRecentSessionsViewModel';
import { DividerStyle } from '@ohos/pcmode';
import { SCBRecentHoverViewModel } from './SCBRecentHoverViewModel';

const TAG = 'SCBRecentEventView';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

@Component
export struct SCBRecentEventView {
  private onGestureChange: Function = (): void => {
  };
  @Prop isPairSplit: boolean = false;
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @ObjectLink sceneSession: SCBSceneSession | null;
  @ObjectLink screenProperty: SCBScreenProperty;
  @Prop singleContext?: SingleContext
  @ObjectLink needRenderRecentCoverTranslate: NeedRenderRecentCoverTranslate;
  @ObjectLink needRenderScale: NeedRenderScale;
  @StorageLink('isRecentCardAnimating') isRecentCardAnimating: boolean = false;

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

  private getRecentCardMaskWidth(): number {
    const width: number = this.getWidth() + SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE +
      SCBRecentStyleConstants.SESSION_OUTER_SIZE;
    log.showInfo(`getRecentCardMaskWidth ${this.sceneSession?.getName()} ${width}`);
    return width;
  }

  private getRecentCardMaskHeight(): number {
    const height: number = this.getSceneHeight() + this.getMarginHeight() + SCBRecentStyleConstants.SESSION_OUTER_SIZE;
    log.showInfo(`getRecentCardMaskHeight ${this.sceneSession?.getName()} ${height}`);
    return height;
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
        SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE + SCBRecentStyleConstants.SPLIT_UP_DOWN_SPACE / 2;
      }
      if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
        return SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE / 2 + SCBRecentStyleConstants.SPLIT_UP_DOWN_SPACE / 2;
      }
    }
    return SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2 +
    SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE +
      SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE / 2;
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
            SCBRecentStyleConstants.SPLIT_UP_DOWN_SPACE / 2
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
    let position: Position = {
      x: 0,
      y: 0
    };
    if (this.sceneContainerSession.dividerParam.isSplitRecentPair) {
      position = this.getSplitRecentPositionForPair();
    } else {
      position = this.getRecentPosition();
    }
    log.showInfo(`getPosition ${this.sceneSession?.getName()} ${position.x} ${position.y}`);
    return position;
  }

  build() {
    Stack()
      .position(this.getPosition())
      .onHover((isHover?: boolean, event?: HoverEvent) => {
        if (!SCBRecentHoverViewModel.isCanHover(this.sceneContainerSession)) {
          log.showInfo('recent state is unStable, can not hover');
          return;
        }
        log.showInfo(`recent session ${this.sceneSession?.getName()} onHover isHover: ${isHover}`);
        if (this.sceneSession) {
          this.sceneSession.hoverState = isHover as boolean;
        }
        SCBRecentHoverViewModel.setRecentHoverState(this.sceneContainerSession, isHover as boolean);
      })
      .onMouse((event: MouseEvent) => {
        if (event.action !== MouseAction.Move) {
          return;
        }
        if (!SCBRecentHoverViewModel.isCanHover(this.sceneContainerSession)) {
          log.showInfo('recent state is unStable, can not hover');
          return;
        }
        if (!this.sceneContainerSession.needRenderRecentHoverState.hoverState) {
          if (this.sceneSession) {
            this.sceneSession.hoverState = true;
          }
          SCBRecentHoverViewModel.setRecentHoverState(this.sceneContainerSession, true);
        }
      })
      .onClick((event?: ClickEvent) => {
        log.showInfo(`onClick recent session ${this.sceneSession?.getName()} ${this.isRecentCardAnimating}`);
        if (!this.isRecentCardAnimating) {
          let instance = SCBSceneSessionManager.getInstance();
          instance.requestFocus(this.sceneSession?.session.persistentId, false);
          instance.startSceneFromRecent(this.screenProperty.screenId, this.sceneSession?.session.persistentId);
        }
      })
      .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
        recognizers: Array<GestureRecognizer>) => {
        if (current.getType() === GestureControl.GestureType.PAN_GESTURE) {
          // when mouse scroll, do onScroll in SCBScenePanel's Scroll
          if (event.source === SourceType.Mouse) {
            return GestureJudgeResult.REJECT;
          }
          // when touch screen scroll, in split recent mode, do onScroll in SCBScenePanel's Scroll
          if (event.source === SourceType.TouchScreen && this.isPairSplit) {
            return GestureJudgeResult.REJECT;
          }
        }
        return GestureJudgeResult.CONTINUE;
      })
      .gesture(
        PanGesture({ fingers: 1, direction: PanDirection.Up, distance: 5 })
          .onActionStart((event: GestureEvent) => {
            log.showInfo(`onActionStart, ${this.sceneSession?.sceneInfo.bundleName}`);
            let action = new SCBGestureAction({
              id: SCBGestureActionId.RECENT_GESTURE_BEGIN,
              sessionId: this.sceneSession?.session.persistentId,
              containerId: this.sceneContainerSession.containerId,
              gestureEvent: event
            });
            this.onGestureChange?.(action);
          })
          .onActionUpdate((event: GestureEvent) => {
            let action = new SCBGestureAction({
              id: SCBGestureActionId.RECENT_GESTURE_UPDATE,
              sessionId: this.sceneSession?.session.persistentId,
              containerId: this.sceneContainerSession.containerId,
              gestureEvent: event
            });
            this.onGestureChange?.(action);
          })
          .onActionEnd((event: GestureEvent) => {
            log.showInfo(`onActionEnd, ${this.sceneSession?.sceneInfo.bundleName}`);
            let action = new SCBGestureAction({
              id: SCBGestureActionId.RECENT_GESTURE_END,
              sessionId: this.sceneSession?.session.persistentId,
              containerId: this.sceneContainerSession.containerId,
              gestureEvent: event
            });
            this.onGestureChange?.(action);
          })
          .onActionCancel(() => {
            log.showInfo(`onActionCancel, ${this.sceneSession?.sceneInfo.bundleName}`);
            let action = new SCBGestureAction({
              id: SCBGestureActionId.RECENT_GESTURE_CANCEL,
              sessionId: this.sceneSession?.session.persistentId,
              containerId: this.sceneContainerSession.containerId,
            });
            this.onGestureChange?.(action);
          })
      )
      .size({
        width: this.getRecentCardMaskWidth(),
        height: this.getRecentCardMaskHeight()
      })
      .focusable(false)
  }
}