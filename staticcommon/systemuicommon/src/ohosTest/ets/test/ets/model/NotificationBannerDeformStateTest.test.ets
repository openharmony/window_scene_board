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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationBannerDeformState } from '../../../main/ets/model/NotificationBannerDeformState';
export default function NotificationBannerDeformStateTest() {
  describe('equal_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_useFakerIcon_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = true;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerToFloating_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = true;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerHeight_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT + 1;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerWidth_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH + 1;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerIconScale_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 2;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerTranX_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 1;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_reset_all_properties_to_default_values', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      notificationbannerdeformstate.reset();

      expect(notificationbannerdeformstate.useFakerIcon).assertEqual(false);
      expect(notificationbannerdeformstate.bannerToFloating).assertEqual(false);
      expect(notificationbannerdeformstate.bannerHeight).assertEqual(66);
      expect(notificationbannerdeformstate.bannerWidth).assertEqual(360);
      expect(notificationbannerdeformstate.bannerIconScale).assertEqual(1);
      expect(notificationbannerdeformstate.bannerTranX).assertEqual(0);
      expect(notificationbannerdeformstate.bannerTranY).assertEqual(0);
      expect(notificationbannerdeformstate.bannerIconTranX).assertEqual(12);
      expect(notificationbannerdeformstate.bannerIconTranY).assertEqual(0);
      expect(notificationbannerdeformstate.bannerTextOpacity).assertEqual(1);
      expect(notificationbannerdeformstate.bannerMaskingOpacity).assertEqual(0);
      expect(notificationbannerdeformstate.bannerMaskingVisibility).assertEqual(false);
      expect(notificationbannerdeformstate.bannerOpacity).assertEqual(1);
    });

    it('should_reset_all_properties_to_default_values', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      notificationbannerdeformstate.reset();

      expect(notificationbannerdeformstate.useFakerIcon).assertEqual(false);
      expect(notificationbannerdeformstate.bannerToFloating).assertEqual(false);
      expect(notificationbannerdeformstate.bannerHeight).assertEqual(66);
      expect(notificationbannerdeformstate.bannerWidth).assertEqual(360);
      expect(notificationbannerdeformstate.bannerIconScale).assertEqual(1);
      expect(notificationbannerdeformstate.bannerTranX).assertEqual(0);
      expect(notificationbannerdeformstate.bannerTranY).assertEqual(0);
      expect(notificationbannerdeformstate.bannerIconTranX).assertEqual(12);
      expect(notificationbannerdeformstate.bannerIconTranY).assertEqual(0);
      expect(notificationbannerdeformstate.bannerTextOpacity).assertEqual(1);
      expect(notificationbannerdeformstate.bannerMaskingOpacity).assertEqual(0);
      expect(notificationbannerdeformstate.bannerMaskingVisibility).assertEqual(false);
      expect(notificationbannerdeformstate.bannerOpacity).assertEqual(1);
    });

    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_useFakerIcon_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = true;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerToFloating_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = true;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerHeight_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT + 1;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerWidth_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH + 1;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerIconScale_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 2;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerTranX_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 1;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_reset_all_properties_to_default_values', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      notificationbannerdeformstate.reset();

      expect(notificationbannerdeformstate.useFakerIcon).assertEqual(false);
      expect(notificationbannerdeformstate.bannerToFloating).assertEqual(false);
      expect(notificationbannerdeformstate.bannerHeight).assertEqual(66);
      expect(notificationbannerdeformstate.bannerWidth).assertEqual(360);
      expect(notificationbannerdeformstate.bannerIconScale).assertEqual(1);
      expect(notificationbannerdeformstate.bannerTranX).assertEqual(0);
      expect(notificationbannerdeformstate.bannerTranY).assertEqual(0);
      expect(notificationbannerdeformstate.bannerIconTranX).assertEqual(12);
      expect(notificationbannerdeformstate.bannerIconTranY).assertEqual(0);
      expect(notificationbannerdeformstate.bannerTextOpacity).assertEqual(1);
      expect(notificationbannerdeformstate.bannerMaskingOpacity).assertEqual(0);
      expect(notificationbannerdeformstate.bannerMaskingVisibility).assertEqual(false);
      expect(notificationbannerdeformstate.bannerOpacity).assertEqual(1);
    });

    it('should_reset_all_properties_to_default_values', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      notificationbannerdeformstate.reset();

      expect(notificationbannerdeformstate.useFakerIcon).assertEqual(false);
      expect(notificationbannerdeformstate.bannerToFloating).assertEqual(false);
      expect(notificationbannerdeformstate.bannerHeight).assertEqual(66);
      expect(notificationbannerdeformstate.bannerWidth).assertEqual(360);
      expect(notificationbannerdeformstate.bannerIconScale).assertEqual(1);
      expect(notificationbannerdeformstate.bannerTranX).assertEqual(0);
      expect(notificationbannerdeformstate.bannerTranY).assertEqual(0);
      expect(notificationbannerdeformstate.bannerIconTranX).assertEqual(12);
      expect(notificationbannerdeformstate.bannerIconTranY).assertEqual(0);
      expect(notificationbannerdeformstate.bannerTextOpacity).assertEqual(1);
      expect(notificationbannerdeformstate.bannerMaskingOpacity).assertEqual(0);
      expect(notificationbannerdeformstate.bannerMaskingVisibility).assertEqual(false);
      expect(notificationbannerdeformstate.bannerOpacity).assertEqual(1);
    });

    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_useFakerIcon_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = true;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerToFloating_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = true;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerHeight_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT + 1;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_bannerWidth_is_different', 0, () => {
      let notificationbannerdeformstate: NotificationBannerDeformState = new NotificationBannerDeformState();
      let bannerDeformState: NotificationBannerDeformState = new NotificationBannerDeformState();
      bannerDeformState.useFakerIcon = false;
      bannerDeformState.bannerToFloating = false;
      bannerDeformState.bannerHeight = DEFAULT_BANNER_HEIGHT;
      bannerDeformState.bannerWidth = DEFAULT_BANNER_WIDTH + 1;
      bannerDeformState.bannerIconScale = 1;
      bannerDeformState.bannerTranX = 0;
      bannerDeformState.bannerTranY = 0;
      bannerDeformState.bannerIconTranX = DEFAULT_ICON_TRAN_X;
      bannerDeformState.bannerIconTranY = 0;
      bannerDeformState.bannerTextOpacity = 1;
      bannerDeformState.bannerMaskingOpacity = 0;
      bannerDeformState.bannerMaskingVisibility = false;
      bannerDeformState.bannerOpacity = 1;

      const result = notificationbannerdeformstate.equal(bannerDeformState);
      expect(result).assertEqual(false);
    });

  });
