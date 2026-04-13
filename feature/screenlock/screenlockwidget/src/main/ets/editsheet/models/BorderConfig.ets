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
import { curves } from '@kit.ArkUI';
import { ENTER_OTHER_APP_BORDER_SHOW } from '@ohos/screenlockcommon/Index';

export enum BorderState {
  HIDE,
  GUIDE,
  IMMERSION,
  PLACEHOLDER
}
const LIGHT_BORDER_COLOR: string = '#99FFFFFF';
const DARK_BORDER_COLOR: string = '#66FFFFFF';
const DRAG_BORDER_COLOR: string = '#33FFFFFF';
const DRAG_BORDER_COLOR_DARK: string = '#40FFFFFF';

export default class BorderConfig {
  public fillColor: ResourceColor = Color.Transparent;
  public fillOpacity: number = 0;
  public borderWidth: ResourceColor = 0;
  public borderRadius: number = 0;
  public visibility: boolean = false;
  public displayMode: number = 0;
  public currentState: BorderState = BorderState.HIDE;
  public borderColor: ResourceColor = '#99ffff';

  constructor(radius: number) {
    this.borderRadius = radius;
  }

  public setBorderState(state: BorderState, isLightWallpaper: boolean, isFormDrag?: boolean, displayMode: number = 0) {
    if (this.currentState === state) {
      return;
    }
    const isNeedExitAni: boolean = BorderState.HIDE === state && ENTER_OTHER_APP_BORDER_SHOW === this.displayMode;
    this.onStateChanged(state, isLightWallpaper, isFormDrag, isNeedExitAni);
    this.currentState = state;
    this.displayMode = displayMode;
  }

  public exit(isLightWallpaper: boolean, isUseAni: boolean = true): void {
    this.fillColor = Color.Transparent;
    if (!isUseAni) {
      this.hideBorder(isLightWallpaper);
      return;
    }
    animateTo({
      curve: curves.cubicBezierCurve(0.1, 0.5, 0.1, 0.5),
      duration: 200
    }, () => {
      this.hideBorder(isLightWallpaper);
    })
  }

  private onStateChanged(cur: BorderState, isLightWallpaper: boolean, isFormDrag?: boolean, isUseAni: boolean = true) {
    if (cur === BorderState.IMMERSION) {
      this.enterEdit(isLightWallpaper);
    } else if (cur === BorderState.PLACEHOLDER) {
      this.enterDrag(isLightWallpaper, isFormDrag ?? false);
    } else if (cur === BorderState.GUIDE) {
      this.enterGuide(isLightWallpaper);
    } else {
      this.exit(isLightWallpaper, isUseAni);
    }
  }

  private hideBorder(isLightWallpaper: boolean): void {
    this.borderColor = isLightWallpaper ? LIGHT_BORDER_COLOR : DARK_BORDER_COLOR;
    this.fillOpacity = 0;
    this.visibility = false;
    this.borderWidth = $r('app.float.edit_border_width');
  }

  public enterGuide(isLightWallpaper: boolean): void {
    this.fillColor = Color.Transparent;
    animateTo({
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
      duration: 150
    }, () => {
      this.borderColor = isLightWallpaper ? LIGHT_BORDER_COLOR : DARK_BORDER_COLOR;
      this.fillOpacity = 0;
      this.visibility = true;
      this.borderWidth = $r('app.float.edit_border_width');
    })
  }

  public enterEdit(isLightWallpaper: boolean): void {
    this.fillColor = Color.Transparent
    animateTo({
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
      duration: 150
    }, () => {
      this.borderColor = isLightWallpaper ? LIGHT_BORDER_COLOR : DARK_BORDER_COLOR;
      this.fillOpacity = 0;
      this.visibility = true;
      this.borderWidth = $r('app.float.edit_border_width_full');
    })
  }

  public enterDrag(isLightWallpaper: boolean, isFormDrag: boolean): void {
    this.fillColor = Color.White
    animateTo({
      curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1),
      duration: 150
    }, () => {
      this.borderColor = isLightWallpaper ? DRAG_BORDER_COLOR : DRAG_BORDER_COLOR_DARK;
      this.fillOpacity = isLightWallpaper ? 0.03 : 0.1;
      this.visibility = true;
      this.borderWidth = isFormDrag ? $r('app.float.edit_border_width_full') : $r('app.float.edit_border_width_drag');
    })
  }
}