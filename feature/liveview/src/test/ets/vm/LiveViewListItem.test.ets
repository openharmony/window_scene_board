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

export default function getLiveListItemFollowScaleTest() {
  describe('getLiveListItemFollowScale', () => {
    it('should_return_scale_x_when_isX_is_true_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(true);
      expect(result).assertEqual(0.5);
    });

    it('should_return_scale_y_when_isX_is_false_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(false);
      expect(result).assertEqual(0.5);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_true_and_isAnimating_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: true,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: false,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_scale_x_when_isX_is_true_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(true);
      expect(result).assertEqual(0.5);
    });

    it('should_return_scale_y_when_isX_is_false_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(false);
      expect(result).assertEqual(0.5);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_true_and_isAnimating_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: true,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: false,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_scale_x_when_isX_is_true_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(true);
      expect(result).assertEqual(0.5);
    });

    it('should_return_scale_y_when_isX_is_false_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(false);
      expect(result).assertEqual(0.5);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_true_and_isAnimating_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: true,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: false,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_scale_x_when_isX_is_true_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(true);
      expect(result).assertEqual(0.5);
    });

    it('should_return_scale_y_when_isX_is_false_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(false);
      expect(result).assertEqual(0.5);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_true_and_isAnimating_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: true,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: false,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_scale_x_when_isX_is_true_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(true);
      expect(result).assertEqual(0.5);
    });

    it('should_return_scale_y_when_isX_is_false_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(false);
      expect(result).assertEqual(0.5);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_true_and_isAnimating_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: true,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: false,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_scale_x_when_isX_is_true_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(true);
      expect(result).assertEqual(0.5);
    });

    it('should_return_scale_y_when_isX_is_false_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(false);
      expect(result).assertEqual(0.5);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_true_and_isAnimating_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: true,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: false,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_scale_x_when_isX_is_true_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(true);
      expect(result).assertEqual(0.5);
    });

    it('should_return_scale_y_when_isX_is_false_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(false);
      expect(result).assertEqual(0.5);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_true_and_isAnimating_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: true,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: false,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_scale_x_when_isX_is_true_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(true);
      expect(result).assertEqual(0.5);
    });

    it('should_return_scale_y_when_isX_is_false_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(false);
      expect(result).assertEqual(0.5);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_true_and_isAnimating_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: true,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: false,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_scale_x_when_isX_is_true_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(true);
      expect(result).assertEqual(0.5);
    });

    it('should_return_scale_y_when_isX_is_false_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(false);
      expect(result).assertEqual(0.5);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_true_and_isAnimating_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: true,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: false,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_scale_x_when_isX_is_true_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(true);
      expect(result).assertEqual(0.5);
    });

    it('should_return_scale_y_when_isX_is_false_and_isSceneAnimating_is_true', 0, () => {
      let instance: any = {
        animState: {
          isSceneAnimating: (scene: number) => true,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale(false);
      expect(result).assertEqual(0.5);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_true_and_isAnimating_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: true,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });

    it('should_return_VALUE_MAX_when_isSceneAnimating_is_false_and_isFollowing_is_false', 0, () => {
      let instance: any = {
        animState: {
          isFollowing: false,
          isAnimating: false,
          getPropertyValue: (type: number) => 0.5
        }
      };
      const result = instance.getLiveListItemFollowScale();
      expect(result).assertEqual(AnimValue.VALUE_MAX);
    });
  });
}