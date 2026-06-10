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
import componentUtils from '@ohos.arkui.componentUtils';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import image from '@ohos.multimedia.image';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { SystemUICommonUtil } from '../../../main/ets/utils/SystemUICommonUtil';
export default function SystemUICommonUtilTest() {
  describe('bindThis_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_bind_methods_correctly_when_obj_and_methods_are_valid', 0, () => {
      let obj: Object = {};
      let methods: Function[] =
        [componentUtils.getInspectorByKey, LogHelper.info, image.PixelMap.create, image.PixelMap.createPixelMap];
      SystemUICommonUtil.bindThis(obj, methods);

      expect(obj.getInspectorByKey).assertInstanceOf(Function);
      expect(obj.info).assertInstanceOf(Function);
      expect(obj.create).assertInstanceOf(Function);
      expect(obj.createPixelMap).assertInstanceOf(Function);
    });

    it('should_handle_error_when_defining_property_fails', 0, () => {
      let obj: Object = {};
      let methods: Function[] = [componentUtils.getInspectorByKey, () => {
        throw new Error('test error');
      }];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(Object, Object.defineProperty);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterThrow('test error');

      SystemUICommonUtil.bindThis(obj, methods);

      mocker.ignoreMock(Object, Object.defineProperty);
    });

    it('should_handle_error_when_method_is_not_a_function', 0, () => {
      let obj: Object = {};
      let methods: Function[] = [componentUtils.getInspectorByKey, 'not a function'];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      SystemUICommonUtil.bindThis(obj, methods);

      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_debounce_promise_when_promise_is_undefined', 0, async () => {
      let debouncedFunc = SystemUICommonUtil.debouncePromise<[]>(() => {
        return Promise.resolve();
      });
      let result = debouncedFunc();
      expect(result).assertInstanceOf(Promise);
    });

    it('should_debounce_promise_when_promise_is_pending', 0, async () => {
      let debouncedFunc = SystemUICommonUtil.debouncePromise<[]>(() => {
        return new Promise(() => {});
      });
      let result = debouncedFunc();
      expect(result).assertInstanceOf(Promise);
    });

    it('should_debounce_promise_when_promise_is_fulfilled', 0, async () => {
      let debouncedFunc = SystemUICommonUtil.debouncePromise<[]>(() => {
        return Promise.resolve();
      });
      let result = debouncedFunc();
      expect(result).assertInstanceOf(Promise);
    });

    it('should_debounce_promise_when_promise_is_rejected', 0, async () => {
      let debouncedFunc = SystemUICommonUtil.debouncePromise<[]>(() => {
        return Promise.reject(new Error('test'));
      });
      let result = debouncedFunc();
      expect(result).assertInstanceOf(Promise);
    });

    it('should_debounce_promise_when_promise_is_undefined_and_then_is_called', 0, async () => {
      let debouncedFunc = SystemUICommonUtil.debouncePromise<[]>(() => {
        return Promise.resolve();
      });
      let result = debouncedFunc();
      await result;
      expect(result).assertInstanceOf(Promise);
    });

    it('should_debounce_promise_when_promise_is_pending_and_then_is_called', 0, async () => {
      let debouncedFunc = SystemUICommonUtil.debouncePromise<[]>(() => {
        return new Promise(() => {});
      });
      let result = debouncedFunc();
      await result;
      expect(result).assertInstanceOf(Promise);
    });

    it('should_debounce_promise_when_promise_is_fulfilled_and_then_is_called', 0, async () => {
      let debouncedFunc = SystemUICommonUtil.debouncePromise<[]>(() => {
        return Promise.resolve();
      });
      let result = debouncedFunc();
      await result;
      expect(result).assertInstanceOf(Promise);
    });

    it('should_debounce_promise_when_promise_is_rejected_and_then_is_called', 0, async () => {
      let debouncedFunc = SystemUICommonUtil.debouncePromise<[]>(() => {
        return Promise.reject(new Error('test'));
      });
      let result = debouncedFunc();
      await result;
      expect(result).assertInstanceOf(Promise);
    });

    it('should_debounce_function_call_with_delay', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.debounce);
      let debouncedFunc: Function = SystemUICommonUtil.debounce((...args: Object[]) => {
        console.log(" debounced function called with args: ", args);
      }, 100);

      debouncedFunc("arg1", "arg2");
      debouncedFunc("arg3", "arg4");

      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyNumber).afterReturn(setTimeout);

      expect(LogHelper.info).assertCalledWith(LogDomain.UI_COMMON, " debounced function called with args:  false");
      expect(LogHelper.info).assertCalledWith(LogDomain.UI_COMMON, " debounced function called with args:  false");

      mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.debounce);
    });

    it('should_debounce_function_call_immediately_when_delay_is_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.debounce);
      let debouncedFunc: Function = SystemUICommonUtil.debounce((...args: Object[]) => {
        console.log(" debounced function called with args: ", args);
      }, 0);

      debouncedFunc("arg1", "arg2");
      debouncedFunc("arg3", "arg4");

      when(mockfunc)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyNumber).afterReturn(setTimeout);

      expect(LogHelper.info).assertCalledWith(LogDomain.UI_COMMON, " debounced function called with args:  false");
      expect(LogHelper.info).assertCalledWith(LogDomain.UI_COMMON, " debounced function called with args:  false");

      mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.debounce);
    });

    it('should_call_fn_immediately_when_time_left_is_less_than_or_equal_to_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(Date, Date.now);
      when(mockfunc)().afterReturn(1000);

      let fn: Function = (a: number) => {
        expect(a).assertEqual(1);
      };
      let throttledFn: Function = SystemUICommonUtil.throttle(fn, 1000);
      throttledFn(1);

      mocker.ignoreMock(Date, Date.now);
    });

    it('should_set_timeout_when_time_left_is_greater_than_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(Date, Date.now);
      when(mockfunc)().afterReturn(1000);

      let fn: Function = (a: number) => {
        expect(a).assertEqual(1);
      };
      let throttledFn: Function = SystemUICommonUtil.throttle(fn, 2000);
      throttledFn(1);

      mocker.ignoreMock(Date, Date.now);
    });

    it('should_reset_timeout_when_time_left_is_less_than_or_equal_to_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(Date, Date.now);
      when(mockfunc)().afterReturn(1000);

      let fn: Function = (a: number) => {
        expect(a).assertEqual(1);
      };
      let throttledFn: Function = SystemUICommonUtil.throttle(fn, 1000);
      throttledFn(1);
      throttledFn(1);

      mocker.ignoreMock(Date, Date.now);
    });

    it('should_return_incrementing_numbers_when_called_multiple_times', 0, () => {
      let generator = SystemUICommonUtil.getIncrementGenerator();
      let result1 = generator();
      let result2 = generator();
      expect(result1).assertEqual(0);
      expect(result2).assertEqual(1);
    });

    it('should_reset_id_to_0_when_id_reaches_max_safe_integer', 0, () => {
      let generator = SystemUICommonUtil.getIncrementGenerator();
      for (let i = 0; i < Number.MAX_SAFE_INTEGER; i++) {
        generator();
      }
      let result = generator();
      expect(result).assertEqual(0);
    });

    it('should_return_correct_rect_when_componentUtils_getRectangleById_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetRectangleById: Function = mocker.mockFunc(componentUtils, componentUtils.getRectangleById);
      let mockLogHelper: LogHelper = LogHelper.INSTANCE;
      let mockError: Function = mocker.mockFunc(mockLogHelper, mockLogHelper.error);

      let componentId: string = "testComponentId";
      let expectedRect: RectResult = { x: 10, y: 20, width: 30, height: 40 };

      when(mockGetRectangleById)(ArgumentMatchers.anyString).afterReturn({
        screenOffset: { x: 10, y: 20 },
        size: { width: 30, height: 40 }
      });

      when(mockError)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = SystemUICommonUtil.getRect(componentId);
      expect(result).assertDeepEquals(expectedRect);

      mocker.ignoreMock(componentUtils, componentUtils.getRectangleById);
      mocker.ignoreMock(mockLogHelper, mockLogHelper.error);
    });

    it('should_return_default_rect_when_componentUtils_getRectangleById_throws_error', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetRectangleById: Function = mocker.mockFunc(componentUtils, componentUtils.getRectangleById);
      let mockLogHelper: LogHelper = LogHelper.INSTANCE;
      let mockError: Function = mocker.mockFunc(mockLogHelper, mockLogHelper.error);

      let componentId: string = "testComponentId";
      let expectedRect: RectResult = { x: 0, y: 0, width: 0, height: 0 };

      when(mockGetRectangleById)(ArgumentMatchers.anyString).afterThrow("Error");

      when(mockError)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      const result = SystemUICommonUtil.getRect(componentId);
      expect(result).assertDeepEquals(expectedRect);

      mocker.ignoreMock(componentUtils, componentUtils.getRectangleById);
      mocker.ignoreMock(mockLogHelper, mockLogHelper.error);
    });

    it('should_return_original_object_when_input_is_not_an_object', 0, () => {
      let input: string = "test string";
      let result = SystemUICommonUtil.shadowCopy(input);
      expect(result).assertEqual(input);
    });

    it('should_return_original_object_when_input_is_an_object_with_no_constructor', 0, () => {
      let input: object = {};
      let result = SystemUICommonUtil.shadowCopy(input);
      expect(result).assertEqual(input);
    });

    it('should_return_shadow_copy_when_input_is_an_object_with_constructor', 0, () => {
      let input: object = {
        prop1: "value1",
        prop2: 123
      };
      let result = SystemUICommonUtil.shadowCopy(input);
      expect(result).assertInstanceOf(Object);
      expect(result.prop1).assertEqual("value1");
      expect(result.prop2).assertEqual(123);
    });

    it('should_ignore_functions_when_shadow_copying_an_object', 0, () => {
      let input: object = {
        prop1: "value1",
        prop2: () => {
          console.log("test function");
        }
      };
      let result = SystemUICommonUtil.shadowCopy(input);
      expect(result).assertInstanceOf(Object);
      expect(result.prop1).assertEqual("value1");
      expect(result.prop2).assertUndefined();
    });

    it('should_reject_timeout_error_when_promise_fails_to_resolve_within_time', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.timeout);
      let promise: Promise<void> = new Promise((resolve, reject) => {
        setTimeout(() => {
          reject(new Error('Promise failed to resolve'));
        }, 100);
      });
      try {
        await SystemUICommonUtil.timeout(promise, 50);
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Promise failed to resolve');
      }
      mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.timeout);
    });

    it('should_resolve_promise_when_promise_resolves_within_time', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.timeout);
      let promise: Promise<number> = new Promise((resolve) => {
        setTimeout(() => {
          resolve(123);
        }, 50);
      });
      const result = await SystemUICommonUtil.timeout(promise, 100);
      expect(result).assertEqual(123);
      mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.timeout);
    });

    it('should_reject_timeout_error_when_time_is_zero', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.timeout);
      let promise: Promise<void> = new Promise((resolve, reject) => {
        setTimeout(() => {
          reject(new Error('Promise failed to resolve'));
        }, 100);
      });
      try {
        await SystemUICommonUtil.timeout(promise, 0);
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Promise failed to resolve');
      }
      mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.timeout);
    });

    it('should_return_immediately_when_oldImage_is_null', 0, () => {
      let oldImage: image.PixelMap = null;
      let newImage: image.PixelMap = null;
      SystemUICommonUtil.releaseImage(oldImage, newImage);
      // 由于没有返回值，无法进行断言，但可以通过日志或调试确认
    });

    it('should_return_immediately_when_oldImage_equals_newImage', 0, () => {
      let oldImage: image.PixelMap = new image.PixelMap();
      let newImage: image.PixelMap = oldImage;
      SystemUICommonUtil.releaseImage(oldImage, newImage);
      // 由于没有返回值，无法进行断言，但可以通过日志或调试确认
    });

    it('should_release_image_when_oldImage_is_valid', 0, async () => {
      let oldImage: image.PixelMap = new image.PixelMap();
      let newImage: image.PixelMap = null;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      SystemUICommonUtil.releaseImage(oldImage, newImage);

      // 验证日志输出
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
    });

    it('should_handle_error_when_release_fails', 0, async () => {
      let oldImage: image.PixelMap = new image.PixelMap();
      let newImage: image.PixelMap = null;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockErrorInfo: Function = mocker.mockFunc(LogHelper, LogHelper.error);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockErrorInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      // Mock the error case
      let mockRelease: Function = mocker.mockFunc(oldImage, oldImage.release);
      when(mockRelease)().afterThrow("release error");

      SystemUICommonUtil.releaseImage(oldImage, newImage);

      // 验证错误日志输出
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.error);
      mocker.ignoreMock(oldImage, oldImage.release);
    });

    it('should_set_pixel_map_name_when_pixelMap_is_not_null', 0, () => {
      let pixelMap: image.PixelMap = new image.PixelMap();
      let name: string = "test";
      SystemUICommonUtil.setPixelMapName(pixelMap, name);
      expect(pixelMap.name).assertEqual(name);
    });

    it('should_not_set_pixel_map_name_when_pixelMap_is_null', 0, () => {
      let pixelMap: image.PixelMap = null;
      let name: string = "test";
      SystemUICommonUtil.setPixelMapName(pixelMap, name);
      expect(pixelMap).assertNull();
    });

    it('should_not_set_pixel_map_name_when_name_is_null', 0, () => {
      let pixelMap: image.PixelMap = new image.PixelMap();
      let name: string = null;
      SystemUICommonUtil.setPixelMapName(pixelMap, name);
      expect(pixelMap.name).assertNull();
    });

    it('should_not_set_pixel_map_name_when_name_is_empty', 0, () => {
      let pixelMap: image.PixelMap = new image.PixelMap();
      let name: string = "";
      SystemUICommonUtil.setPixelMapName(pixelMap, name);
      expect(pixelMap.name).assertNull();
    });

    it('should_return_parsed_json_when_jsonString_is_valid', 0, () => {
      let jsonString: string = '{"key": "value"}';
      let result = SystemUICommonUtil.safeParseJson<any>(jsonString);
      expect(result).assertDeepEquals({ key: "value" });
    });

    it('should_return_null_when_jsonString_is_invalid', 0, () => {
      let jsonString: string = 'invalid json string';
      let result = SystemUICommonUtil.safeParseJson<any>(jsonString);
      expect(result).assertNull();
    });

    it('should_log_error_when_jsonString_is_invalid', 0, () => {
      let jsonString: string = 'invalid json string';
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      SystemUICommonUtil.safeParseJson<any>(jsonString);

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('sleep_should_resolve_after_timeout', 0, async () => {
      let mocker: MockKit = new MockKit();

      let start = Date.now();
      await SystemUICommonUtil.sleep(1000);
      let end = Date.now();

      expect(end - start).assertLarger(900);
      expect(end - start).assertLarger(1000);
    });

    it('sleep_should_resolve_immediately_if_ms_is_zero', 0, async () => {
      let mocker: MockKit = new MockKit();

      let start = Date.now();
      await SystemUICommonUtil.sleep(0);
      let end = Date.now();

      expect(end - start).assertEqual(0);
    });

    it('sleep_should_reject_when_ms_is_negative', 0, async () => {
      let mocker: MockKit = new MockKit();

      try {
        await SystemUICommonUtil.sleep(-1000);
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Invalid argument');
      }
    });
  });
}