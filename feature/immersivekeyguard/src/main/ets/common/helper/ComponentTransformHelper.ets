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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ComponentAnimState, PropertyType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { WidgetAnimState } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/bean/WidgetAnimState'
import {
  WBaseProperty
} from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/constants/WidgetPropertyConst';
import { CmpPosWrapper } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/utils/ComponentPosition';

const TAG = 'ComponentTransformHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class CmpStateWrapper {
  private animState: ComponentAnimState | WidgetAnimState;

  constructor(animState: ComponentAnimState | WidgetAnimState) {
    this.animState = animState;
  }

  static wrapper(animState: ComponentAnimState | WidgetAnimState): CmpStateWrapper {
    return new CmpStateWrapper(animState);
  }

  setScale(scaleX: number, scaleY: number): void {
    if (this.animState instanceof ComponentAnimState) {
      let animState = this.animState as ComponentAnimState;
      animState.setPropertyValue(PropertyType.SCALE_X, scaleX);
      animState.setPropertyValue(PropertyType.SCALE_Y, scaleY);
    }
    if (this.animState instanceof WidgetAnimState) {
      let animState = this.animState as WidgetAnimState;
      animState.setScaleX(scaleX);
      animState.setScaleY(scaleY);
    }
  }

  setBorderRadius(radius: number): void {
    if (this.animState instanceof ComponentAnimState) {
      let animState = this.animState as ComponentAnimState;
      animState.setRadiusValue(radius);
    }
    if (this.animState instanceof WidgetAnimState) {
      let animState = this.animState as WidgetAnimState;
      animState.setBorderRadius(radius);
    }
  }

  setTranslate(tranX: number, tranY: number): void {
    if (this.animState instanceof ComponentAnimState) {
      let animState = this.animState as ComponentAnimState;
      animState.setPropertyValue(PropertyType.TRAN_X, tranX);
      animState.setPropertyValue(PropertyType.TRAN_Y, tranY);
    }
    if (this.animState instanceof WidgetAnimState) {
      let animState = this.animState as WidgetAnimState;
      animState.setTranX(tranX);
      animState.setTranY(tranY);
    }
  }

  setRect(width: number, height: number): void {
    if (this.animState instanceof ComponentAnimState) {
      let animState = this.animState as ComponentAnimState;
      animState.setPropertyValue(PropertyType.WIDTH, width);
      animState.setPropertyValue(PropertyType.HEIGHT, height);
    }
    if (this.animState instanceof WidgetAnimState) {
      let animState = this.animState as WidgetAnimState;
      animState.setWidth(width);
      animState.setHeight(height);
    }
  }

  setWidth(width: number): void {
    if (this.animState instanceof ComponentAnimState) {
      let animState = this.animState as ComponentAnimState;
      animState.setPropertyValue(PropertyType.WIDTH, width);
    }
    if (this.animState instanceof WidgetAnimState) {
      let animState = this.animState as WidgetAnimState;
      animState.setWidth(width);
    }
  }

  setAlpha(alpha: number): void {
    if (this.animState instanceof ComponentAnimState) {
      let animState = this.animState as ComponentAnimState;
      animState.setPropertyValue(PropertyType.ALPHA, alpha);
    }
    if (this.animState instanceof WidgetAnimState) {
      let animState = this.animState as WidgetAnimState;
      animState.setAlpha(alpha);
    }
  }

  setZIndex(index: number): void {
    if (this.animState instanceof ComponentAnimState) {
      let animState = this.animState as ComponentAnimState;
      animState.setPropertyValue(PropertyType.INDEX, index);
    }
    if (this.animState instanceof WidgetAnimState) {
      let animState = this.animState as WidgetAnimState;
      animState.setZIndex(index);
    }
  }

  setAnimating(isAnimating: boolean, scene: string): void {
    if (this.animState instanceof ComponentAnimState) {
      let animState = this.animState as ComponentAnimState;
      animState.setAnimating(isAnimating, scene)
    }
    if (this.animState instanceof WidgetAnimState) {
      let animState = this.animState as WidgetAnimState;
      animState.setAnimScene({
        isAnimating: isAnimating,
        animScene: scene
      })
    }
  }

  clearAnimState(): void {
    if (this.animState instanceof ComponentAnimState) {
      let animState = this.animState as ComponentAnimState;
      this.clearComponentAnimState(animState);
    }
    if (this.animState instanceof WidgetAnimState) {
      let animState = this.animState as WidgetAnimState;
      this.clearWidgetAnimState(animState);
    }
  }

  private clearComponentAnimState(state: ComponentAnimState) {
    state.clearProperty(PropertyType.TRAN_X)
      .clearProperty(PropertyType.TRAN_Y)
      .clearProperty(PropertyType.SCALE_X)
      .clearProperty(PropertyType.SCALE_Y)
      .clearProperty(PropertyType.ALPHA)
      .clearProperty(PropertyType.INDEX)
      .clearRadius()
  }

  private clearWidgetAnimState(state: WidgetAnimState) {
    state.clearProperty(WBaseProperty.TRAN_X)
      .clearProperty(WBaseProperty.TRAN_Y)
      .clearProperty(WBaseProperty.SCALE_X)
      .clearProperty(WBaseProperty.SCALE_Y)
      .clearProperty(WBaseProperty.ALPHA)
      .clearProperty(WBaseProperty.Z_INDEX)
      .clearBorderRadius()
  }
}

/**
 * 状态转换
 */
export class ComponentTransformHelper {
  static transformComponent(sourceState?: CmpStateWrapper, sourcePos?: CmpPosWrapper, targetPos?: CmpPosWrapper): void {
    if (sourceState && sourcePos?.isPosValid() && targetPos?.isPosValid()) {
      let tranX = targetPos.getCmpCenterX() - sourcePos.getCmpCenterX();
      let tranY = targetPos.getCmpCenterY() - sourcePos.getCmpCenterY();
      let scaleX = targetPos.getCmpWidth() / sourcePos.getCmpWidth();
      let scaleY = targetPos.getCmpHeight() / sourcePos.getCmpHeight();
      sourceState.setScale(scaleX, scaleY);
      sourceState.setTranslate(tranX, tranY);
      sourceState.setBorderRadius(targetPos.getCmpRadius() / Math.max(scaleX, scaleY));
    } else {
      log.showWarn('transformComponent error');
    }
  }
}