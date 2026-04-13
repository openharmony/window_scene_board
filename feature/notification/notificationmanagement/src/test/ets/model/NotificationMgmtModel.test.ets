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

export default function GetSlotsTest() {
  describe('getSlots', () => {
    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });
    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });
    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });

    it('should_return_slots_when_getSlotsByBundle_succeeds', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      const result = await ra.getSlots();
      expect(result).assertDeepEquals(mockSlots);

    });

    it('should_return_error_when_getSlotsByBundle_throws_exception', 0, async () => {
      let bundleOption: notificationManager.BundleOption = {};
      let ra: GetSlots = new GetSlots();
      ra.bundleOption = bundleOption;
      let mocker: MockKit = new MockKit();


      try {
        await ra.getSlots();
        assertFail('Expected an error to be thrown');
      } catch (e) {
        expect(e.message).assertEqual('Error');
      }

    });
  });
}