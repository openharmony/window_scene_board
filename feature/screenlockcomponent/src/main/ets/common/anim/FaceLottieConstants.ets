/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 */

/**
 * 人脸lottie资源的名称和路径
 */
export default class FaceLottieConstants {
  /**
   * 人脸识别开始的lottie名称
   */
  public static readonly FACE_LOCK: string = 'face_lock';

  /**
   * 人脸识别开始的lottie路径
   */
  public static readonly FACE_LOCK_PATH: string = 'SceneBoard/screenlock/lottie/face_lock.json';

  /**
   * 人脸识别loop的lottie名称
   */
  public static readonly FACE_LOOP: string = 'face_loop';

  /**
   * 人脸识别loop的lottie路径
   */
  public static readonly FACE_LOOP_PATH: string = 'SceneBoard/screenlock/lottie/face_loop.json';

  /**
   * 人脸识别rotate_loop的lottie名称
   */
  public static readonly FACE_ROTATE_LOOP: string = 'face_rotate_loop';

  /**
   * 人脸识别rotate_loop的lottie路径
   */
  public static readonly FACE_ROTATE_LOOP_PATH: string = 'SceneBoard/screenlock/lottie/face_rotate_loop.json';

  /**
   * 人脸识别成功的lottie名称
   */
  public static readonly FACE_UNLOCK_SUCCESS: string = 'face_unlock_success';

  /**
   * 人脸识别成功的lottie路径
   */
  public static readonly FACE_UNLOCK_SUCCESS_PATH: string = 'SceneBoard/screenlock/lottie/face_unlock_success.json';

  /**
   * 人脸识别失败的lottie名称
   */
  public static readonly FACE_UNLOCK_FAIL: string = 'face_unlock_fail';

  /**
   * 人脸识别失败的lottie路径
   */
  public static readonly FACE_UNLOCK_FAIL_PATH: string = 'SceneBoard/screenlock/lottie/face_unlock_fail.json';

  /**
   * 人脸识别lottie名称数组
   */
  public static readonly FACE_LOTTIE_NAME: string[] = [FaceLottieConstants.FACE_LOCK, FaceLottieConstants.FACE_LOOP,
    FaceLottieConstants.FACE_ROTATE_LOOP, FaceLottieConstants.FACE_UNLOCK_SUCCESS,
    FaceLottieConstants.FACE_UNLOCK_FAIL];

  /**
   * 人脸识别lottie路径数组
   */
  public static readonly FACE_LOTTIE_PATH: string[] =
    [FaceLottieConstants.FACE_LOCK_PATH, FaceLottieConstants.FACE_LOOP_PATH,
      FaceLottieConstants.FACE_ROTATE_LOOP_PATH, FaceLottieConstants.FACE_UNLOCK_SUCCESS_PATH,
      FaceLottieConstants.FACE_UNLOCK_FAIL_PATH];

  /**
   * 密码界面人脸识别失败的lottie名称
   */
  public static readonly PSD_FACE_FAIL: string = 'psd_face_fail';

  /**
   * 密码界面人脸识别失败的lottie路径
   */
  public static readonly PSD_FACE_FAIL_PATH: string = 'screenlock_face_lottie/psd_face_fail.json';
  public static readonly PSD_FACE_FAIL_PATH_NEW: string = 'SceneBoard/screenlock/lottie/psd_face_fail.json';

  /**
   * 密码界面人脸识别成功的lottie名称
   */
  public static readonly PSD_FACE_SUCCESS: string = 'psd_face_success';

  /**
   * 密码界面人脸识别成功的lottie路径
   */
  public static readonly PSD_FACE_SUCCESS_PATH: string = 'screenlock_face_lottie/psd_face_success.json';
  public static readonly PSD_FACE_SUCCESS_PATH_NEW: string = 'SceneBoard/screenlock/lottie/psd_face_success.json';

  /**
   * 密码界面人脸识别中的lottie名称
   */
  public static readonly PSD_FACE_BREATH: string = 'psd_face_breath';

  /**
   * 密码界面人脸识别中的lottie路径
   */
  public static readonly PSD_FACE_BREATH_PATH: string = 'screenlock_face_lottie/psd_face_breath.json';
  public static readonly PSD_FACE_BREATH_PATH_NEW: string = 'SceneBoard/screenlock/lottie/face_loop.json';

  /**
   * 密码界面人脸detected的lottie名称
   */
  public static readonly PSD_FACE_DETECTED: string = 'psd_face_detected';

  /**
   * 密码界面人脸detected的lottie路径
   */
  public static readonly PSD_FACE_DETECTED_PATH: string = 'screenlock_face_lottie/psd_face_detected.json';
  public static readonly PSD_FACE_DETECTED_PATH_NEW: string = 'SceneBoard/screenlock/lottie/face_rotate_loop.json';

  /**
   * 密码界面人脸识别中的lottie
   */
  public static readonly PSD_FACE_LOTTIE_NAME: string[] =
    [FaceLottieConstants.PSD_FACE_BREATH, FaceLottieConstants.PSD_FACE_DETECTED,
      FaceLottieConstants.PSD_FACE_SUCCESS, FaceLottieConstants.PSD_FACE_FAIL];
}