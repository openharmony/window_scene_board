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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AnimationNames } from '@ohos/systemuicommon/src/main/ets/animation/AnimationNames';
import { AnimateParams, AnimationBase } from '@ohos/systemuicommon/src/main/ets/animation/AnimationBase';
import curves from '@ohos.curves';
import { INotificationCardVm } from '@ohos/systemuicommon/newIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationItemAppearAnimation } from '../../../main/ets/animation/NotificationItemAppearAnimation';
export default function NotificationItemAppearAnimationTest() {
  describe('addLastItemAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_addAnimation_with_correct_params', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 0, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_equals_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 0, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_equals_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 0, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_equals_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 0, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_equals_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 0, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_equals_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 0, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_equals_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 0, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_equals_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 0, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_equals_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 0, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_equals_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 0, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_equals_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(1, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });

    it('should_call_addAnimation_with_correct_params_when_index_greater_than_firstIndex', 0, async () => {
      let notificationitemappearanimation: NotificationItemAppearAnimation = new NotificationItemAppearAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationitemappearanimation.addLastItemAnimation(2, 1, event);

      mocker.ignoreMock(notificationitemappearanimation, notificationitemappearanimation.addAnimation);
    });
  });
}