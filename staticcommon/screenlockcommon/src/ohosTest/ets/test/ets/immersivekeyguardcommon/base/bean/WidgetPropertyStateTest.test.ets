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

import { it, describe, expect } from '@ohos/hypium';
import { BaseState } from '../../../../../../../main/ets/immersivekgcommon/base/bean/BaseState';
import { WidgetPropertyState } from '../../../../../../../main/ets/immersivekgcommon/base/bean/WidgetPropertyState';
import {
  WBaseProperty,
  WLimitValue,
  WProperty
} from '../../../../../../../main/ets/immersivekgcommon/base/constants/WidgetPropertyConst';

class TestPropertyState extends WidgetPropertyState<TestPropertyState> {
  protected getTarInstance(): TestPropertyState {
    return this;
  }
}

export function WidgetPropertyStateTest() {
  describe('WidgetPropertyStateTest', (): void => {
    it('test_initWidgetPropertyState', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      expect(testInstance instanceof TestPropertyState).assertTrue();
    });
    it('test_setStateValue', 0, (): void => {
      let property: WProperty = WBaseProperty.ALPHA;
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.setStateValue(property);
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getStateValue', 0, (): void => {
      let property: WProperty = WBaseProperty.ALPHA;
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      testInstance.getStateValue(property);
      expect(true).assertTrue();
    });
    it('test_addChildState', 0, (): void => {
      let property: WProperty = WBaseProperty.ALPHA;
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.setStateValue(property);
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_removeChildState', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.removeChildState('10');
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getChildState', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.getChildState('10');
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setLimitValue', 0, (): void => {
      let property: WProperty = WBaseProperty.ALPHA;
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.setLimitValue(property);
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_clearProperty', 0, (): void => {
      let property: WProperty = WBaseProperty.ALPHA;
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.clearProperty(property);
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_beginChildSet', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.beginChildSet();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_endChildSet', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.endChildSet();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setAlpha', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.setAlpha(10);
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getAlpha', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.getAlpha();
      expect(res !==undefined).assertTrue();
    });
    it('test_setTranX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.setTranX(10);
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getTranX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.getTranX();
      expect(res !==undefined).assertTrue();
    });
    it('test_setTranY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.setTranY(10);
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getTranY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.getTranY();
      expect(res !==undefined).assertTrue();
    });
    it('test_getTranZ', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.getTranZ();
      expect(res !==undefined).assertTrue();
    });
    it('test_setTranZ', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.setTranZ(10);
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setScaleX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.setScaleX(1);
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getScaleX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.getScaleX();
      expect(res !==undefined).assertTrue();
    });
    it('test_setScaleY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.setScaleY(10);
      expect(res instanceof TestPropertyState).assertTrue();
    });

    it('test_getScaleY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'WidgetPropertyState');
      let res = testInstance.getTranY();
      expect(res !==undefined).assertTrue();
    });
    it('test_setScaleZ', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setScaleZ(10);
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getScaleZ', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getScaleZ();
      expect(res !==undefined).assertTrue();
    });
    it('test_setScaleCenterX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setScaleCenterX();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getScaleCenterX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getScaleCenterX();
      expect(res !==undefined).assertTrue();
    });
    it('test_setScaleCenterY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setScaleCenterY();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getScaleCenterY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getScaleCenterY();
      expect(res !==undefined).assertTrue();
    });

    it('test_setRotateX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setRotateX();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getRotateX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getRotateX();
      expect(res !==undefined).assertTrue();
    });
    it('test_setRotateY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setRotateY();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getRotateY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getRotateY();
      expect(res !==undefined).assertTrue();
    });
    it('test_setRotateZ', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setRotateZ();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getRotateZ', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getRotateZ();
      expect(res !==undefined).assertTrue();
    });
    it('test_setRotatePerspective', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setRotatePerspective();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getRotatePerspective', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getRotatePerspective();
      expect(res !==undefined).assertTrue();
    });
    it('test_setRotateAngle', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setRotateAngle();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getRotateAngle', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getRotateAngle();
      expect(res !==undefined).assertTrue();
    });
    it('test_setRotateCenterX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setRotateCenterX();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setRotateCenterY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setRotateCenterY();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getRotateCenterX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getRotateCenterX();
      expect(res !==undefined).assertTrue();
    });
    it('test_getRotateCenterY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getRotateCenterY();
      expect(res !==undefined).assertTrue();
    });
    it('test_setRotateCenterZ', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setRotateCenterZ();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getRotateCenterZ', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getRotateCenterZ();
      expect(res !==undefined).assertTrue();
    });
    it('test_setWidth', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setWidth();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getWidth', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getWidth();
      expect(res !==undefined).assertTrue();
    });
    it('test_setHeight', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setHeight();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getHeight', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getHeight();
      expect(res !==undefined).assertTrue();
    });
    it('test_setClip', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setClip();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_isClipEnable', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.isClipEnable();
      expect(res !==undefined).assertTrue();
    });
    it('test_setClipWidth', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setClipWidth();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getClipWidth', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getClipWidth();
      expect(res !==undefined).assertTrue();
    });
    it('test_setClipHeight', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setClipHeight();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getClipHeight', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getClipHeight();
      expect(res !==undefined).assertTrue();
    });
    it('test_setClipOffsetX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setClipOffsetX();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getClipOffsetX', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getClipOffsetX();
      expect(res !==undefined).assertTrue();
    });
    it('test_setClipOffsetY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setClipOffsetY();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getClipOffsetY', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getClipOffsetY();
      expect(res !==undefined).assertTrue();
    });
    it('test_setBorderRadiusTL', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setBorderRadiusTL();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getBorderRadiusTL', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getBorderRadiusTL();
      expect(res !==undefined).assertTrue();
    });
    it('test_setBorderRadiusTR', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setBorderRadiusTR();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getBorderRadiusTR', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getBorderRadiusTR();
      expect(res !==undefined).assertTrue();
    });
    it('test_setBorderRadiusBL', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setBorderRadiusBL();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getBorderRadiusBL', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getBorderRadiusBL();
      expect(res !==undefined).assertTrue();
    });
    it('test_getBorderRadiusBR', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getBorderRadiusBR();
      expect(res !==undefined).assertTrue();
    });
    it('test_clearBorderRadius', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.clearBorderRadius();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setBorderRadius', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setBorderRadius();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setMarginL', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setMarginL();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getMarginL', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getMarginL();
      expect(res !==undefined).assertTrue();
    });
    it('test_setMarginR', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setMarginR();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setMarginT', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setMarginT();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getMarginT', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getMarginT();
      expect(res !==undefined).assertTrue();
    });
    it('test_setMarginB', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setMarginB();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getMarginB', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getMarginB();
      expect(res !==undefined).assertTrue();
    });
    it('test_setPaddingL', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setPaddingL();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getPaddingL', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getPaddingL();
      expect(res !==undefined).assertTrue();
    });
    it('test_setPaddingR', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setPaddingR();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getPaddingR', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getPaddingR();
      expect(res !==undefined).assertTrue();
    });
    it('test_setPaddingT', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setPaddingT();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getPaddingT', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getPaddingT();
      expect(res !==undefined).assertTrue();
    });
    it('test_setPaddingB', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setPaddingB();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getPaddingB', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getPaddingB();
      expect(res !==undefined).assertTrue();
    });
    it('test_setFontSize', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setFontSize();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getFontSize', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getFontSize();
      expect(res !==undefined).assertTrue();
    });
    it('test_setFontColor', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setFontColor();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getFontColor', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getFontColor();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setFontFamily', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setFontFamily();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getFontFamily', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getFontFamily();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setFontWeight', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setFontWeight();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getFontWeight', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getFontWeight();
      expect(res !==undefined).assertTrue();
    });
    it('test_setFontFeature', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setFontFeature();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getFontFeature', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getFontFeature();
      expect(res !==undefined).assertTrue();
    });
    it('test_setMaxLines', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setMaxLines();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getMaxLines', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getMaxLines();
      expect(res !==undefined).assertTrue();
    });
    it('test_setTextOverflow', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setTextOverflow();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getTextOverflow', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getTextOverflow();
      expect(res !==undefined).assertTrue();
    });
    it('test_setMinFontScale', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setMinFontScale();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setMaxFontScale', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setMaxFontScale();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getMaxFontScale', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getMaxFontScale();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_setDraggable', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setDraggable();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_isDraggable', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.isDraggable();
      expect(res !==undefined).assertTrue();
    });
    it('test_setRenderGroup', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setRenderGroup();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_isRenderGroup', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.isRenderGroup();
      expect(res !==undefined).assertTrue();
    });
    it('test_setUseEffect', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setUseEffect();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_isUseEffect', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.isUseEffect();
      expect(res !==undefined).assertTrue();
    });
    it('test_setBlur', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setBlur();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getBlur', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getBlur();
      expect(res !==undefined).assertTrue();
    });
    it('test_setLinearBlur', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setLinearBlur();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getLinearBlur', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getLinearBlur();
      expect(res !==undefined).assertTrue();
    });
    it('test_setZIndex', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setZIndex();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getZIndex', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getZIndex();
      expect(res !==undefined).assertTrue();
    });
    it('test_setPosition', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setPosition();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getPosition', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getPosition();
      expect(res !==undefined).assertTrue();
    });
    it('test_setOffset', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setOffset();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getOffset', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getOffset();
      expect(res !==undefined).assertTrue();
    });
    it('test_setMarkAnchor', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setMarkAnchor();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getMarkAnchor', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getMarkAnchor();
      expect(res !==undefined).assertTrue();
    });
    it('test_setVisibility', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setVisibility();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getVisibility', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getVisibility();
      expect(res !==undefined).assertTrue();
    });
    it('test_setAlignContent', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setAlignContent();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getAlignContent', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getAlignContent();
      expect(res !==undefined).assertTrue();
    });
    it('test_setTransition', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setTransition();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getTransition', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getTransition();
      expect(res !==undefined).assertTrue();
    });
    it('test_setWidgetId', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setWidgetId();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getWidgetId', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getWidgetId();
      expect(res !==undefined).assertTrue();
    });
    it('test_setGeometryId', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setGeometryId();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getGeometryId', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getGeometryId();
      expect(res !==undefined).assertTrue();
    });
    it('test_setBlendMode', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setBlendMode();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getBlendMode', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getBlendMode();
      expect(res !==undefined).assertTrue();
    });
    it('test_setAlignRules', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setAlignRules();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getAlignRules', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getAlignRules();
      expect(res !==undefined).assertTrue();
    });
    it('test_setBgColor', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setBgColor();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getBgColor', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getBgColor();
      expect(res !==undefined).assertTrue();
    });
    it('test_setBrightness', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setFgBrightness();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getBrightness', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getFgBrightness();
      expect(res !==undefined).assertTrue();
    });
    it('test_setLightUpEffect', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.setLightUpEffect();
      expect(res instanceof TestPropertyState).assertTrue();
    });
    it('test_getLightUpEffect', 0, (): void => {
      let testInstance: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let res = testInstance.getLightUpEffect();
      expect(res !==undefined).assertTrue();
    });
    it('TestPropertyStateTest_001', 0, (): void => {
      let widgetPropertyS: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      widgetPropertyS.beginChildSet();
      widgetPropertyS.setAlpha(0.9);
      widgetPropertyS.setTranX(1);
      widgetPropertyS.setTranY(1);
      widgetPropertyS.setTranZ(1);
      widgetPropertyS.setScaleX(0.1);
      widgetPropertyS.setScaleY(0.1);
      widgetPropertyS.setScaleZ(0.1);
      widgetPropertyS.setScaleCenterX(0.1);
      widgetPropertyS.setScaleCenterY(0.1);
      widgetPropertyS.setRotateX(1);
      widgetPropertyS.setRotateY(1);
      widgetPropertyS.setRotateZ(1);
      widgetPropertyS.setRotatePerspective(1);
      widgetPropertyS.setRotateAngle(1);
      widgetPropertyS.setRotateCenterX(1);
      widgetPropertyS.setRotateCenterY(1);
      widgetPropertyS.setRotateCenterZ(1);
      widgetPropertyS.setWidth(1);
      widgetPropertyS.setHeight(1);
      widgetPropertyS.setClip(true);
      widgetPropertyS.setClipWidth(1);
      widgetPropertyS.setClipHeight(1);
      widgetPropertyS.setClipOffsetX(1);
      widgetPropertyS.setClipOffsetY(1);
      widgetPropertyS.setBorderRadiusTL(1);
      widgetPropertyS.setBorderRadiusTR(1);
      widgetPropertyS.setBorderRadiusBL(1);
      widgetPropertyS.setBorderRadiusBR(1);
      widgetPropertyS.setBorderRadius(1);
      widgetPropertyS.setMarginL(1);
      widgetPropertyS.setMarginR(1);
      widgetPropertyS.setMarginT(1);
      widgetPropertyS.setMarginB(1);
      widgetPropertyS.setPaddingL(1);
      widgetPropertyS.setPaddingR(1);
      widgetPropertyS.setPaddingT(1);
      widgetPropertyS.setPaddingB(1);
      widgetPropertyS.setFontSize(1);
      widgetPropertyS.setFontColor(1);
      widgetPropertyS.setFontFamily('testFontFamily');
      widgetPropertyS.setFontWeight(1);
      widgetPropertyS.setFontFeature('testFeature');
      widgetPropertyS.setMaxLines(1);
      widgetPropertyS.setTextOverflow(1);
      widgetPropertyS.setMinFontScale(1);
      widgetPropertyS.setMaxFontScale(1);
      widgetPropertyS.setDraggable(true);
      widgetPropertyS.setRenderGroup(true);
      widgetPropertyS.setUseEffect(true);
      widgetPropertyS.setBlur(1);
      widgetPropertyS.setLinearBlur(1);
      widgetPropertyS.setZIndex(1);
      widgetPropertyS.setPosition({});
      widgetPropertyS.setOffset({});
      widgetPropertyS.setMarkAnchor({});
      widgetPropertyS.setVisibility(0);
      widgetPropertyS.setAlignContent(0);
      widgetPropertyS.setTransition();
      widgetPropertyS.setWidgetId('testId');
      widgetPropertyS.setGeometryId('testId');
      widgetPropertyS.setBlendMode(0);
      widgetPropertyS.setAlignRules({});
      widgetPropertyS.setBgColor(1);
      let value: BrightnessOptions = {
        rate: 0,
        lightUpDegree: 0,
        cubicCoeff: 0,
        quadCoeff: 0,
        saturation: 0,
        posRGB: [0, 0, 0],
        negRGB: [0, 0, 0],
        fraction: 0
      };
      widgetPropertyS.setFgBrightness(value);
      widgetPropertyS.setLightUpEffect(1);

      widgetPropertyS.endChildSet();
      widgetPropertyS.setTranX(1);
      widgetPropertyS.setTranY(1);
      widgetPropertyS.setTranZ(1);
      widgetPropertyS.setScaleX(0.1);
      widgetPropertyS.setScaleY(0.1);
      widgetPropertyS.setScaleZ(0.1);
      widgetPropertyS.setTranX(1);
      widgetPropertyS.setTranY(1);
      widgetPropertyS.setTranZ(1);
      widgetPropertyS.setScaleX(0.1);
      widgetPropertyS.setScaleY(0.1);
      widgetPropertyS.setScaleZ(0.1);
      widgetPropertyS.setScaleCenterX(0.2);
      widgetPropertyS.setScaleCenterY(0.2);
      widgetPropertyS.setRotateX(2);
      widgetPropertyS.setRotateY(2);
      widgetPropertyS.setRotateZ(2);
      widgetPropertyS.setRotatePerspective(2);
      widgetPropertyS.setRotateAngle(2);
      widgetPropertyS.setRotateCenterX(2);
      widgetPropertyS.setRotateCenterY(2);
      widgetPropertyS.setRotateCenterZ(2);
      widgetPropertyS.setWidth(2);
      widgetPropertyS.setHeight(2);
      widgetPropertyS.setClip(false);
      widgetPropertyS.setClipWidth(2);
      widgetPropertyS.setClipHeight(2);
      widgetPropertyS.setClipOffsetX(2);
      widgetPropertyS.setClipOffsetY(2);
      widgetPropertyS.setBorderRadiusTL(2);
      widgetPropertyS.setBorderRadiusTR(2);
      widgetPropertyS.setBorderRadiusBL(2);
      widgetPropertyS.setBorderRadiusBR(2);
      widgetPropertyS.setBorderRadius(2);
      widgetPropertyS.setMarginL(2);
      widgetPropertyS.setMarginR(2);
      widgetPropertyS.setMarginT(2);
      widgetPropertyS.setMarginB(2);
      widgetPropertyS.setPaddingL(2);
      widgetPropertyS.setPaddingR(2);
      widgetPropertyS.setPaddingT(2);
      widgetPropertyS.setPaddingB(2);
      widgetPropertyS.setFontSize(2);
      widgetPropertyS.setFontColor(2);
      widgetPropertyS.setFontFamily('testFontFamily1');
      widgetPropertyS.setFontWeight(2);
      widgetPropertyS.setFontFeature('testFeature1');
      widgetPropertyS.setMaxLines(2);
      widgetPropertyS.setTextOverflow(2);
      widgetPropertyS.setMinFontScale(2);
      widgetPropertyS.setMaxFontScale(2);
      widgetPropertyS.setDraggable(false);
      widgetPropertyS.setRenderGroup(false);
      widgetPropertyS.setUseEffect(false);
      widgetPropertyS.setBlur(2);
      widgetPropertyS.setLinearBlur(2);
      widgetPropertyS.setZIndex(2);
      widgetPropertyS.setPosition({x: 1});
      widgetPropertyS.setOffset({x: 1});
      widgetPropertyS.setMarkAnchor({x: 1});
      widgetPropertyS.setVisibility(1);
      widgetPropertyS.setAlignContent(1);
      widgetPropertyS.setTransition();
      widgetPropertyS.setWidgetId('testId1');
      widgetPropertyS.setGeometryId('testId');
      widgetPropertyS.setBlendMode(1);
      widgetPropertyS.setAlignRules({left: { anchor: 'string', align: HorizontalAlign.Start }});
      widgetPropertyS.setBgColor(2);
      let value1: BrightnessOptions = {
        rate: 1,
        lightUpDegree: 1,
        cubicCoeff: 1,
        quadCoeff: 1,
        saturation: 1,
        posRGB: [1, 1, 1],
        negRGB: [1, 1, 1],
        fraction: 1
      };
      widgetPropertyS.setFgBrightness(value1);
      widgetPropertyS.setLightUpEffect(2);
      expect(widgetPropertyS != null).assertTrue();
    });
    it("TestPropertyStateTest_002", 0, () => {
      let widgetPropertyS: TestPropertyState = BaseState.wrap(TestPropertyState, 'TestPropertyState');
      let limit: WLimitValue = {
        minValue: 0.5,
        maxValue: 1,
        buildMinValue: (minValue?: number | undefined): WLimitValue => {
          throw new Error('Function not implemented.');
        },
        buildMaxValue: (maxValue?: number | undefined): WLimitValue => {
          throw new Error('Function not implemented.');
        }
      };
      widgetPropertyS.setLimitValue(WBaseProperty.ALPHA, limit);
      (widgetPropertyS as object)['getValidValue'](WBaseProperty.ALPHA, 0.1);
      expect(widgetPropertyS != null).assertTrue();
    });
  });
}