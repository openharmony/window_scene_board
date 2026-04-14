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
import { CommonUtils } from '@ohos/basicutils';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationAnimationParas } from '../../../main/ets/common/NotificationAnimationParas';
export default function NotificationAnimationParasTest() {
  describe('resolveClipAnimWait_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_resolve_clip_anim_wait_when_clip_anim_wait_is_not_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = new CustomPromise<void>();
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertUndefined();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });
    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });
    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });
    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });

    it('should_do_nothing_when_clip_anim_wait_is_null', 0, () => {
      let notificationanimationparas: NotificationAnimationParas = new NotificationAnimationParas(1, 2, 3, 4, 5);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.setTimeout);
      when(mockfunc)(ArgumentMatchers.anyFunction).afterReturn(null);

      notificationanimationparas.clipAnimWait = null;
      notificationanimationparas.resolveClipAnimWait();

      expect(notificationanimationparas.clipAnimWait).assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.setTimeout);
    });
  });
}