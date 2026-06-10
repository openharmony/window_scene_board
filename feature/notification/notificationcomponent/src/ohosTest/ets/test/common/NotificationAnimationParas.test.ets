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
import { CommonUtils } from '@ohos/basicutils';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationAnimationParas } from '../../../main/ets/common/NotificationAnimationParas';
export default function NotificationAnimationParasTest() {
  describe('setItemPreSizeChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_NotificationAnimationParas_instance_when_listener_is_undefined', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
      let result = notificationanimationparas.setItemPreSizeChange();
      expect(result).assertInstanceOf(NotificationAnimationParas);
    });

    it('should_return_NotificationAnimationParas_instance_when_listener_is_provided', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
      let listener: OnItemPreSizeChange = new OnItemPreSizeChange();
      let result = notificationanimationparas.setItemPreSizeChange(listener);
      expect(result).assertInstanceOf(NotificationAnimationParas);
    });

    it('should_set_itemPreSizeChange_to_listener_when_listener_is_provided', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
      let listener: OnItemPreSizeChange = new OnItemPreSizeChange();
      notificationanimationparas.setItemPreSizeChange(listener);
      expect(notificationanimationparas.itemPreSizeChange).assertDeepEquals(listener);
    });

    it('should_set_itemPreSizeChange_to_undefined_when_listener_is_undefined', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
      notificationanimationparas.setItemPreSizeChange();
      expect(notificationanimationparas.itemPreSizeChange).assertUndefined();
    });

  });
  it('should_call_itemPreSizeChange_when_isForceAnim_is_true', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(notificationanimationparas, notificationanimationparas.updateItemPresSize);
    when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(notificationanimationparas);

    const result = notificationanimationparas.updateItemPresSize(true);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    mocker.ignoreMock(notificationanimationparas, notificationanimationparas.updateItemPresSize);
  });
  it('should_not_call_itemPreSizeChange_when_isForceAnim_is_false', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(notificationanimationparas, notificationanimationparas.updateItemPresSize);
    when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(notificationanimationparas);

    const result = notificationanimationparas.updateItemPresSize(false);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    mocker.ignoreMock(notificationanimationparas, notificationanimationparas.updateItemPresSize);
  });
  it('should_return_instance_of_NotificationAnimationParas_when_itemPreSizeChange_is_not_null', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(notificationanimationparas, notificationanimationparas.updateItemPresSize);
    when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(notificationanimationparas);

    const result = notificationanimationparas.updateItemPresSize(false);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    mocker.ignoreMock(notificationanimationparas, notificationanimationparas.updateItemPresSize);
  });

  it('should_return_instance_of_NotificationAnimationParas_when_itemPreSizeChange_is_null', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    notificationanimationparas.itemPreSizeChange = null;
    const result = notificationanimationparas.updateItemPresSize(false);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });
  it('should_return_false_when_isDisableEffect_is_undefined', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    notificationanimationparas.isDisableEffect = undefined;
    const result = notificationanimationparas.isTempDisableEffect();
    expect(result).assertEqual(false);
  });

  it('should_return_true_when_isDisableEffect_is_true', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    notificationanimationparas.isDisableEffect = true;
    const result = notificationanimationparas.isTempDisableEffect();
    expect(result).assertEqual(true);
  });
  it('should_return_false_when_isDisableEffect_is_false', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    notificationanimationparas.isDisableEffect = false;
    const result = notificationanimationparas.isTempDisableEffect();
    expect(result).assertEqual(false);
  });
  it('should_return_true_when_isItemTouchEnable_is_true', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
    notificationanimationparas.isItemTouchEnable = true;
    const result = notificationanimationparas.isItemEnable();
    expect(result).assertEqual(true);
  });

  it('should_return_false_when_isItemTouchEnable_is_false', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
    notificationanimationparas.isItemTouchEnable = false;
    const result = notificationanimationparas.isItemEnable();
    expect(result).assertEqual(false);
  });
  it('should_return_true_when_isItemTouchEnable_is_undefined_and_clearAnimOpacity_is_greater_than_0.8', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
    notificationanimationparas.clearAnimOpacity = 0.9;
    const result = notificationanimationparas.isItemEnable();
    expect(result).assertEqual(true);
  });

  it('should_return_false_when_isItemTouchEnable_is_undefined_and_clearAnimOpacity_is_less_than_0.8', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
    notificationanimationparas.clearAnimOpacity = 0.7;
    const result = notificationanimationparas.isItemEnable();
    expect(result).assertEqual(false);
  });
  it('should_return_true_when_isItemTouchEnable_is_undefined_and_clearAnimOpacity_is_null', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
    notificationanimationparas.clearAnimOpacity = null;
    const result = notificationanimationparas.isItemEnable();
    expect(result).assertEqual(true);
  });
  it('should_return_clipAnim_when_clipAnim_is_not_null', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(notificationanimationparas, notificationanimationparas.getClipAnim);
    let clipAnim: AnimateParam = new AnimateParam();
    when(mockfunc)().afterReturn(clipAnim);
    const result = notificationanimationparas.getClipAnim();
    expect(result).assertEqual(clipAnim);
    mocker.ignoreMock(notificationanimationparas, notificationanimationparas.getClipAnim);
  });

  it('should_return_undefined_when_clipAnim_is_null', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(notificationanimationparas, notificationanimationparas.getClipAnim);
    when(mockfunc)().afterReturn(null);
    const result = notificationanimationparas.getClipAnim();
    expect(result).assertUndefined();
    mocker.ignoreMock(notificationanimationparas, notificationanimationparas.getClipAnim);
  });
  it('should_return_NotificationAnimationParas_when_isExpanded_is_true', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateGroupExpanded(true);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.isGroupExpanded).assertTrue();
  });

  it('should_return_NotificationAnimationParas_when_isExpanded_is_false', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateGroupExpanded(false);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.isGroupExpanded).assertFalse();
  });
  it('should_return_current_instance_when_isEnable_is_undefined', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateItemTouchEnable();
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });

  it('should_return_current_instance_when_isEnable_is_true', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateItemTouchEnable(true);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });

  it('should_return_current_instance_when_isEnable_is_false', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateItemTouchEnable(false);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });
  it('should_return_current_instance_when_updateTranY_is_called', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateTranY(6);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });

  it('should_update_ntfItemTranslateY_when_updateTranY_is_called', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateTranY(6);
    expect(result.ntfItemTranslateY).assertEqual(6);
  });

  it('should_not_update_ntfItemTranslateY_when_updateTranY_is_called_with_same_value', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateTranY(2);
    expect(result.ntfItemTranslateY).assertEqual(2);
  });
  it('should_return_current_instance_when_updateTranY_is_called_with_same_value', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateTranY(2);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });
  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_valid_alpha_value', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.5);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.5);
  });

  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_1', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.9999999999);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.9999999999);
  });
  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.0000000001);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.0000000001);
  });

  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0.5', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.4999999999);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.4999999999);
  });
  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0.01', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.01);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.01);
  });

  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0.99', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.99);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.99);
  });
  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0.000001', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.000001);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.000001);
  });

  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0.999999', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.999999);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.999999);
  });
  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0.0000001', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.0000001);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.0000001);
  });

  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0.9999999', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.9999999);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.9999999);
  });

  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0.00000001', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.00000001);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.00000001);
  });
  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0.99999999', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.99999999);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.99999999);
  });

  it('should_return_correct_NotificationAnimationParas_object_when_updateAlpha_is_called_with_alpha_value_close_to_0.000000001', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateAlpha(0.000000001);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimOpacity).assertEqual(0.000000001);
  });
  it('should_return_correct_NotificationAnimationParas_object_when_updateScale_is_called_with_valid_scale_value', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateScale(6);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimScale).assertEqual(6);
  });
  it('should_return_correct_NotificationAnimationParas_object_when_updateScale_is_called_with_scale_value_0', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateScale(0);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimScale).assertEqual(0);
  });
  it('should_return_correct_NotificationAnimationParas_object_when_updateScale_is_called_with_scale_value_less_than_0', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateScale(-6);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimScale).assertEqual(-6);
  });

  it('should_return_correct_NotificationAnimationParas_object_when_updateScale_is_called_with_scale_value_close_to_0', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateScale(0.0001);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimScale).assertEqual(0.0001);
  });
  it('should_return_correct_NotificationAnimationParas_object_when_updateScale_is_called_with_scale_value_close_to_0_but_less_than_0', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result: NotificationAnimationParas = notificationanimationparas.updateScale(-0.0001);
    expect(result).assertInstanceOf(NotificationAnimationParas);
    expect(result.clearAnimScale).assertEqual(-0.0001);
  });
  it('should_return_current_instance_when_centerY_is_undefined', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY();
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });

  it('should_return_current_instance_when_centerY_is_null', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(null);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });
  it('should_return_current_instance_when_centerY_is_a_number', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(100);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });

  it('should_update_itemScaleCenterY_when_centerY_is_a_number', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(100);
    expect(result.itemScaleCenterY).assertEqual(100);
  });

  it('should_return_current_instance_when_centerY_is_a_number_less_than_zero', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(-100);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });
  it('should_update_itemScaleCenterY_when_centerY_is_a_number_less_than_zero', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(-100);
    expect(result.itemScaleCenterY).assertEqual(-100);
  });

  it('should_return_current_instance_when_centerY_is_a_number_greater_than_zero', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(100);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });

  it('should_update_itemScaleCenterY_when_centerY_is_a_number_greater_than_zero', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(100);
    expect(result.itemScaleCenterY).assertEqual(100);
  });
  it('should_return_current_instance_when_centerY_is_a_number_close_to_zero', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(0.000001);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });

  it('should_update_itemScaleCenterY_when_centerY_is_a_number_close_to_zero', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(0.000001);
    expect(result.itemScaleCenterY).assertEqual(0.000001);
  });

  it('should_return_current_instance_when_centerY_is_a_number_close_to_negative_zero', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(-0.000001);
    expect(result).assertInstanceOf(NotificationAnimationParas);
  });
  it('should_update_itemScaleCenterY_when_centerY_is_a_number_close_to_negative_zero', 0, () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let result = notificationanimationparas.updateScaleCenterY(-0.000001);
    expect(result.itemScaleCenterY).assertEqual(-0.000001);
  });
  it('should_resolve_immediately_when_clipAnimWait_is_undefined', 0, async () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    notificationanimationparas.clipAnimWait = undefined;
    await notificationanimationparas.startClipAnimWait();
  });

  it('should_resolve_immediately_when_clipAnimWait_is_null', 0, async () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    notificationanimationparas.clipAnimWait = null;
    await notificationanimationparas.startClipAnimWait();
  });

  it('should_resolve_when_clipAnimWait_is_resolved', 0, async () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isPromiseResolved);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    await notificationanimationparas.startClipAnimWait();
    mocker.ignoreMock(CommonUtils, CommonUtils.isPromiseResolved);
  });

  it('should_reject_when_clipAnimWait_is_rejected', 0, async () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isPromiseResolved);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    try {
      await notificationanimationparas.startClipAnimWait();
      assertFail("Expected an error to be thrown");
    } catch (e) {
      expect(e.message).assertEqual("clipAnimWait is rejected");
    }
    mocker.ignoreMock(CommonUtils, CommonUtils.isPromiseResolved);
  });
  it('should_reject_when_clipAnimWait_is_rejected_1', 0, async () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isPromiseResolved);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    try {
      await notificationanimationparas.startClipAnimWait();
      assertFail("Expected an error to be thrown");
    } catch (e) {
      expect(e.message).assertEqual("clipAnimWait is rejected");
    }
    mocker.ignoreMock(CommonUtils, CommonUtils.isPromiseResolved);
  });
  it('should_reject_when_clipAnimWait_is_rejected_2', 0, async () => {
    let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isPromiseResolved);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    try {
      await notificationanimationparas.startClipAnimWait();
      assertFail("Expected an error to be thrown");
    } catch (e) {
      expect(e.message).assertEqual("clipAnimWait is rejected");
    }
    mocker.ignoreMock(CommonUtils, CommonUtils.isPromiseResolved);
  });
}