/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
  FloatingSceneCommonStyle,
  FloatingScenePortraitStyle,
  SCBFloatingParam,
  SCBSceneContainerSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSystemSceneSession,
  SystemSessionInfo,
  windowMgr
} from "@ohos/windowscene"
import { SCBDefaultZIndex } from "./SCBScreen";
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBFloatManager } from "./multiwindow/SCBFloatManager";
import { LogHelper, LogDomain } from "@ohos/basicutils";
import { WindowConstants } from "@ohos/commonconstants";

const TAG = 'SCBScalingScene';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);


// 缩放灵敏度（越小越平滑，推荐 0.6 ~ 0.9）
const SCALE_SENSITIVITY = 0.7;
const FLOATING_SCENE_FOCUSED_SHADOW_COLOR = $r('app.color.floating_scene_focused_shadow_color');
const FLOATING_SCENE_UNFOCUSED_SHADOW_COLOR = $r('app.color.floating_scene_unfocused_shadow_color');
const FLOATING_SCENE_FOCUSED_SHADOW_RADIUS = $r('app.float.floating_scene_focused_shadow_radius');
const FLOATING_SCENE_UNFOCUSED_SHADOW_RADIUS = $r('app.float.floating_scene_unfocused_shadow_radius');
const FLOATING_SCENE_FOCUSED_SHADOW_OFFSET_X = $r('app.float.floating_scene_focused_shadow_offset_x');
const FLOATING_SCENE_UNFOCUSED_SHADOW_OFFSET_X = $r('app.float.floating_scene_unfocused_shadow_offset_x');
const FLOATING_SCENE_FOCUSED_SHADOW_OFFSET_Y = $r('app.float.floating_scene_focused_shadow_offset_y');
const FLOATING_SCENE_UNFOCUSED_SHADOW_OFFSET_Y = $r('app.float.floating_scene_unfocused_shadow_offset_y');
const FLOATING_SCENE_FOCUSED_BORD_COLOR = $r('app.color.ohos_id_color_emphasize');
const FLOATING_SCENE_UNFOCUSED_BORD_COLOR = '#B2B3B3B3';

@Component
export struct SCBScalingScene {
  @Link sceneContainerSession: SCBSceneContainerSession;
  @Link @Watch('onOrientationChanged') screenProperty: SCBScreenProperty;
  @Link floatingParam: SCBFloatingParam;
  @State baseW: number = px2vp(this.screenProperty.width * FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO);
  @State baseH: number =
    this.screenProperty.width < this.screenProperty.height ? this.baseW / FloatingScenePortraitStyle.ASPECT_RATIO :
      this.baseW * FloatingScenePortraitStyle.ASPECT_RATIO;
  // windowscene
  private systemSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PANEL,
    sceneName: TAG,
    sceneZIndex: SCBDefaultZIndex.SYSTEM_SCENE_PANEL,
    isFocusable: true,
    isTouchable: true,
    privacyMode: false,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
    isOverlayScene: true,
    isRotatable: true
  };
  private sysSceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.systemSessionInfo, undefined, false, this.screenProperty.screenId)
  // 缩放拖拽相关
  private startX: number = 0;
  private startY: number = 0;
  private oldPosX: number = 0;
  private oldPosY: number = 0;
  private startPosX: number = this.baseW * (1 - FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO) / 2;
  private startPosY: number = this.baseH * (1 - FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO) / 2;
  private startWidth: number = 0;
  private startTouchX: number = 0;
  private startTouchY: number = 0;
  private startScale: number = 1;
  private scaleCenterX: number | string = 0;
  private statusBarHeight: number = this.getStatusBarHeight();
  private minScale: number =
    FloatingScenePortraitStyle.ORIGINAL_MIN_WIDTH_RATIO / FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO;
  private maxScale: number =
    FloatingScenePortraitStyle.ORIGINAL_MAX_WIDTH_RATIO / FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO;
  private touchRegionType: string = '';
  private handleDrag = (event: TouchEvent) => {
    if (this.floatingParam.isFloatEdgeDrag) { // 缩放时禁止拖拽
      return;
    }
    const touchX = event.touches[0].displayX;
    const touchY = event.touches[0].displayY;

    switch (event.type) {
      case TouchType.Down:
        this.startX = touchX;
        this.startY = touchY;
        this.startPosX = this.sceneContainerSession.needRenderPos.posX;
        this.startPosY = this.sceneContainerSession.needRenderPos.posY;
        this.floatingParam.isFloatDragging = true;
        break;

      case TouchType.Move:
        if (this.floatingParam.isFloatDragging) {
          const deltaX = touchX - this.startX;
          const deltaY = touchY - this.startY;
          this.oldPosX = this.startPosX + deltaX;
          this.oldPosY = Math.max(this.startPosY + deltaY, this.statusBarHeight);
          this.sceneContainerSession.needRenderPos.setPosX(this.oldPosX);
          this.sceneContainerSession.needRenderPos.setPosY(this.oldPosY);
        }
        break;

      case TouchType.Up:
      case TouchType.Cancel:
        this.floatingParam.isFloatDragging = false;
        break;
    }
  }
  private handleScale = (event: TouchEvent) => {
    // 拖拽时禁止缩放
    if (this.floatingParam.isFloatDragging) {
      return;
    }
    const touchX = event.touches[0].displayX;
    const touchY = event.touches[0].displayY;

    switch (event.type) {
      case TouchType.Down: {
        this.floatingParam.isFloatEdgeDrag = true;
        this.startTouchX = touchX;
        this.startTouchY = touchY;
        this.startScale = this.sceneContainerSession.needRenderScale.scaleX;
        this.startPosX = this.sceneContainerSession.needRenderPos.posX;
        this.startWidth = this.baseW * this.startScale;
        const touchW = event.touches[0].x * this.startScale;
        // 判断触摸区域类型
        if (touchW < this.startWidth / 3) {
          // 左侧 1/3（A）
          this.touchRegionType = 'A';
        } else if (touchW < this.startWidth * 2 / 3) {
          // 中间 1/3（B）
          this.touchRegionType = 'B';
        } else {
          // 右侧 1/3（C）
          this.touchRegionType = 'C';
        }
        this.sceneContainerSession.needRenderScale.centerX = this.scaleCenterX;
        break;
      }

      case TouchType.Move: {
        if (!this.floatingParam.isFloatEdgeDrag || this.touchRegionType === '') {
          return;
        }
        const deltaX = touchX - this.startTouchX;
        const deltaY = touchY - this.startTouchY;
        let scaleDelta = 0;
        if (this.touchRegionType === 'A') {
          scaleDelta = -deltaX / this.baseW;
        } else if (this.touchRegionType === 'B') {
          scaleDelta = deltaY / this.baseH;
        } else if (this.touchRegionType === 'C') {
          scaleDelta = deltaX / this.baseW;
        }
        let newScale = this.startScale + scaleDelta * SCALE_SENSITIVITY;
        // 限制缩放范围
        newScale = Math.max(this.minScale, Math.min(this.maxScale, newScale));

        // 计算需要补充的位移
        let offsetX = 0;
        if (this.touchRegionType === 'A') {
          offsetX = this.baseW * (this.startScale - newScale);
        } else if (this.touchRegionType === 'B') {
          offsetX = this.baseW * (this.startScale - newScale) / 2;
        } else if (this.touchRegionType === 'C') {
          offsetX = 0;
        }
        this.sceneContainerSession.needRenderScale.setScaleX(newScale);
        this.sceneContainerSession.needRenderScale.setScaleY(newScale);
        this.oldPosX = this.startPosX + offsetX;
        this.sceneContainerSession.needRenderPos.setPosX(this.oldPosX);
        break;
      }

      case TouchType.Up:
      case TouchType.Cancel: {
        this.floatingParam.isFloatEdgeDrag = false;
        this.touchRegionType = '';
        break;
      }
    }
  }
  private oldOrientation: number = this.screenProperty.rotation;
  private orientationTimer: number = -1;

  private onOrientationChanged() {
    let rotation = this.screenProperty.rotation;
    if (this.oldOrientation === rotation) {
      return;
    }
    if(Math.abs(this.oldOrientation - rotation) === 180) {
      this.oldOrientation = rotation;
      return;
    }
    log.showInfo('onOrientationChanged, rotation: ' + rotation);
    // debounce 处理，因为有时会短时间内多次回调。
    if (this.orientationTimer !== -1) {
      clearTimeout(this.orientationTimer);
    }
    this.orientationTimer = setTimeout(() => {
      this.onOrientation();
      this.orientationTimer = -1;
    }, 100);
    this.oldOrientation = rotation;
  }

  private onOrientation() {
    let tmp = this.baseW;
    this.baseW = this.baseH;
    this.baseH = tmp;
    const statusBarHeight = this.getStatusBarHeight();
    if (this.oldPosY === 0 && this.oldPosX === 0) {
      this.sceneContainerSession.needRenderPos.setPosX(this.startPosY);
      this.sceneContainerSession.needRenderPos.setPosY(this.startPosX);
    } else if (this.oldPosY < statusBarHeight || this.oldPosX < statusBarHeight || this.oldPosY > this.baseH || this.oldPosX > this.baseW / 2) {
      // 防止旋转后无法点击关闭或移动，在超界后归位到初始位置。
      this.startPosX = this.baseW * (1 - FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO) / 2;
      this.startPosY = this.baseH * (1 - FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO) / 2;
      this.sceneContainerSession.needRenderPos.setPosX(this.startPosX);
      this.sceneContainerSession.needRenderPos.setPosY(this.startPosY);
    } else {
      this.sceneContainerSession.needRenderPos.setPosX(this.oldPosY);
      this.sceneContainerSession.needRenderPos.setPosY(this.oldPosX);
    }
  }

  private getStatusBarHeight(): number {
    let statusBarH: number = px2vp(windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height);
    if (statusBarH !== 0) {
      statusBarH++;
    }
    return Math.ceil(statusBarH);
  }

  private exitApp() {
    SCBFloatManager.getInstance().exitFloatWithAnimator(this.sceneContainerSession);
  }

  private getWindowSceneResponseRegion(onWindow: boolean): Rectangle[] {
    let tmp: Rectangle = {
      x: 0,
      y: 0,
      width: vp2px(this.baseW),
      height: vp2px(FloatingSceneCommonStyle.TITLE_BAR_BTN_HEIGHT)
    }
    let result: Rectangle[] = this.getResponseRegion(onWindow)
    result.push(tmp);
    return result;

  }

  private getResponseRegion(onWindow: boolean = false): Rectangle[] {
    let regionPosY = FloatingSceneCommonStyle.TITLE_BAR_BTN_HEIGHT / FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO;
    let leftRegion: Rectangle = {
      x: -FloatingSceneCommonStyle.DRAG_HOT_WIDTH_OUTER,
      y: regionPosY,
      width: FloatingSceneCommonStyle.DRAG_HOT_WIDTH_OUTER + FloatingSceneCommonStyle.DRAG_HOT_WIDTH_INNER,
      height: this.baseH - regionPosY
    }
    let bottomRegion: Rectangle = {
      x: -FloatingSceneCommonStyle.DRAG_HOT_WIDTH_OUTER,
      y: this.baseH - FloatingSceneCommonStyle.DRAG_HOT_WIDTH_INNER,
      width: this.baseW + FloatingSceneCommonStyle.DRAG_HOT_WIDTH_OUTER * 2,
      height: FloatingSceneCommonStyle.DRAG_HOT_WIDTH_INNER + FloatingSceneCommonStyle.DRAG_HOT_WIDTH_OUTER
    }
    let rightRegion: Rectangle = {
      x: this.baseW - FloatingSceneCommonStyle.DRAG_HOT_WIDTH_INNER,
      y: regionPosY,
      width: FloatingSceneCommonStyle.DRAG_HOT_WIDTH_INNER + FloatingSceneCommonStyle.DRAG_HOT_WIDTH_OUTER,
      height: this.baseH - regionPosY
    }
    return [leftRegion, bottomRegion, rightRegion].map((rect) => {
      if (onWindow) {
        let newRect: Rectangle = {
          x: vp2px(rect.x as number),
          y: vp2px(rect.y as number),
          width: vp2px(rect.width as number),
          height: vp2px(rect.height as number)
        }
        return newRect;
      } else {
        return rect;
      }
    })
  }

  @Builder
  buildDragPoint(w: number = 6) {
    Blank()
      .backgroundColor(this.floatingParam.isFloatDragging ? $r('app.color.ohos_id_color_emphasize') : '#B2B3B3B3')
      .width(w)
      .height(6)
      .borderRadius(3)
  }

  build() {
    WindowScene(this.sysSceneSession.session.persistentId) {
      Stack({ alignContent: Alignment.Top }) {
        Row({ space: 4 }) {
          this.buildDragPoint()
          this.buildDragPoint(16)
          this.buildDragPoint()
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width(FloatingSceneCommonStyle.TITLE_BAR_BTN_WIDTH)
        .height(FloatingSceneCommonStyle.TITLE_BAR_BTN_HEIGHT)
        .onTouch(this.handleDrag)

        Stack({ alignContent: Alignment.End }) {
          Image($r('app.media.ic_public_cancel_filled'))
            .width(24)
            .aspectRatio(1)
            .onClick(() => {
              this.exitApp();
            })
        }
        .hitTestBehavior(HitTestMode.Transparent)
        .padding({ right: 15 })
        .width('100%')
        .height(FloatingSceneCommonStyle.TITLE_BAR_BTN_HEIGHT)
      }
      .height('100%')
      .width('100%')
      .responseRegion(this.getResponseRegion())
      .borderWidth(2)
      .borderColor(this.floatingParam.isFloatEdgeDrag ? FLOATING_SCENE_FOCUSED_BORD_COLOR :
        FLOATING_SCENE_UNFOCUSED_BORD_COLOR)
      .borderRadius(this.sceneContainerSession.needRenderBorderRadius)
      .shadow({
        color: this.floatingParam.isFloatEdgeDrag ? FLOATING_SCENE_FOCUSED_SHADOW_COLOR :
          FLOATING_SCENE_UNFOCUSED_SHADOW_COLOR,
        radius: this.floatingParam.isFloatEdgeDrag ? FLOATING_SCENE_FOCUSED_SHADOW_RADIUS :
          FLOATING_SCENE_UNFOCUSED_SHADOW_RADIUS,
        offsetX: this.floatingParam.isFloatEdgeDrag ? FLOATING_SCENE_FOCUSED_SHADOW_OFFSET_X :
          FLOATING_SCENE_UNFOCUSED_SHADOW_OFFSET_X,
        offsetY: this.floatingParam.isFloatEdgeDrag ? FLOATING_SCENE_FOCUSED_SHADOW_OFFSET_Y :
          FLOATING_SCENE_UNFOCUSED_SHADOW_OFFSET_Y
      })
      .onTouch(this.handleScale)

    }
    .id(`session${this.sysSceneSession.session.persistentId}`)
    .responseRegion(this.getWindowSceneResponseRegion(true))
    .hitTestBehavior(HitTestMode.None)
  }
}