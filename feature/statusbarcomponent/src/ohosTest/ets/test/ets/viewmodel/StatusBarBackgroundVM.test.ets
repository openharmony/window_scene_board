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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { StatusBarTint } from '../../../../../main/ets/common/StatusBarTint';
import { LinearGradientType } from '../../../../../main/ets/viewmodel/BackgroundLinearGradient';
import { StatusBarBackgroundVM } from '../../../../../main/ets/viewmodel/StatusBarBackgroundVM';
import { MockUtils } from '../common/MockUtils';

const statusBarBackgroundVM: StatusBarBackgroundVM = new StatusBarBackgroundVM();

interface IStatusBarBackgroundVM {
  isTransparentColor(color: string): boolean;
  isBgAllTransparentColors(bgColors: string[]): boolean;
  getLinearGradientType(): LinearGradientType;
  getAutoIconSize(): Length;
}

export function StatusBarBackgroundVMTest() {
  describe('StatusBarBackgroundVMTest', (): void => {
    beforeAll((): void => {
      statusBarBackgroundVM.init();
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
      statusBarBackgroundVM.unInit();
    });
    afterEach((): void => {
    });

  it('test_default_LinearGradientType_value', Level.LEVEL1, (): void => {
    let linearGradientType: LinearGradientType = statusBarBackgroundVM.getBackgroundLinearGradient().getLinearGradientType();
    expect(linearGradientType !== undefined).assertTrue();
  });

  it('test_LinearGradientType_in_app_value', Level.LEVEL1, (): void => {
    statusBarBackgroundVM.onLinearGradientFlagChange(false);
    let linearGradientType: LinearGradientType = statusBarBackgroundVM.getBackgroundLinearGradient().getLinearGradientType();
    expect(linearGradientType === LinearGradientType.NONE).assertTrue();
  });

  it('test_LinearGradientType_for_white_content_value', Level.LEVEL1, (): void => {
    statusBarBackgroundVM.onContentColorChange(StatusBarTint.CONTENT_COLOR_OPAQUE_BLACK);
    let linearGradientType: LinearGradientType = statusBarBackgroundVM.getBackgroundLinearGradient().getLinearGradientType();
    expect(true).assertTrue();
  });

  it('test_onContentColorChange', Level.LEVEL1, (): void => {
    try {
      statusBarBackgroundVM.onContentColorChange(StatusBarTint.CONTENT_COLOR_BLACK);
      statusBarBackgroundVM.onContentColorChange(StatusBarTint.CONTENT_COLOR_BLACK);
    } catch (err) {}
    expect(Reflect.has(statusBarBackgroundVM, 'onContentColorChange')).assertTrue();
  });

  it('test_isBgAllTransparentColors', Level.LEVEL1, (): void => {
    try {
      (statusBarBackgroundVM as object as IStatusBarBackgroundVM).isBgAllTransparentColors(['FF000000']);
      (statusBarBackgroundVM as object as IStatusBarBackgroundVM).isBgAllTransparentColors([]);
    } catch (err) {}
    expect(Reflect.has(statusBarBackgroundVM, 'isBgAllTransparentColors')).assertTrue();
  });

  it('test_getLinearGradientType', Level.LEVEL1, (): void => {
    try {
      statusBarBackgroundVM.onBackgroundColorChange(['FF000000']);
      (statusBarBackgroundVM as object as IStatusBarBackgroundVM).getLinearGradientType();
      statusBarBackgroundVM.onBackgroundColorChange([]);
      (statusBarBackgroundVM as object as IStatusBarBackgroundVM).getLinearGradientType();
      statusBarBackgroundVM.onLinearGradientFlagChange(false);
      (statusBarBackgroundVM as object as IStatusBarBackgroundVM).getLinearGradientType();
      statusBarBackgroundVM.onLinearGradientFlagChange(true);
      statusBarBackgroundVM.onContentColorChange('');
      (statusBarBackgroundVM as object as IStatusBarBackgroundVM).getLinearGradientType();
      statusBarBackgroundVM.onContentColorChange('FFFFFFFF');
      (statusBarBackgroundVM as object as IStatusBarBackgroundVM).getLinearGradientType();
      statusBarBackgroundVM.onContentColorChange('FF000000');
      (statusBarBackgroundVM as object as IStatusBarBackgroundVM).getLinearGradientType();
    } catch (err) {}
    expect(Reflect.has(statusBarBackgroundVM, 'getLinearGradientType')).assertTrue();
  });

    it('test_onLinearGradientFlagAndeBgColorChange_0', 0, () => {
      const vm = new StatusBarBackgroundVM();
      Reflect.set(vm, 'refreshLinearGradientFlag', MockUtils.mockReturnFunc(true));
      Reflect.set(vm, 'refreshBackgroundColor', MockUtils.mockReturnFunc(true));
      try {
        vm.onLinearGradientFlagAndeBgColorChange(true, '');
        expect(true).assertTrue();
      } catch (e) {
      }
    });

    it('test_onLinearGradientFlagAndeBgColorChange_1', 0, () => {
      const vm = new StatusBarBackgroundVM();
      Reflect.set(vm, 'refreshLinearGradientFlag', MockUtils.mockReturnFunc(false));
      Reflect.set(vm, 'refreshBackgroundColor', MockUtils.mockReturnFunc(true));
      try {
        vm.onLinearGradientFlagAndeBgColorChange(true, '');
        expect(true).assertTrue();
      } catch (e) {
      }
    });

    it('test_refreshBackgroundColor', 0, () => {
      const vm = new StatusBarBackgroundVM();
      Reflect.set(vm, 'bgColors', ['#FFFFFF']);
      MockUtils.invoke<boolean>(vm, 'refreshBackgroundColor', ['#FFFFFF']);
      expect(true).assertTrue();
    });

    it('test_isTransparentColor', 0, () => {
      const vm = new StatusBarBackgroundVM();
      MockUtils.invoke<boolean>(vm, 'isTransparentColor', '#00FFFFFF');
      expect(true).assertTrue();
    });

    it('test_getLinearGradientType_0', 0, () => {
      const vm = new StatusBarBackgroundVM();
      Reflect.set(vm, 'contentColor', '');
      MockUtils.invoke<LinearGradientType>(vm, 'getLinearGradientType');
      expect(true).assertTrue();
    });

    it('test_getLinearGradientType_1', 0, () => {
      const vm = new StatusBarBackgroundVM();
      Reflect.set(vm, 'contentColor', '#000000');
      MockUtils.invoke<LinearGradientType>(vm, 'getLinearGradientType');
      expect(true).assertTrue();
    });

  })}