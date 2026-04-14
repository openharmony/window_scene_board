/**
 * 悬浮窗显示模式
 */
export enum FloatingDisplayMode {
  /**
   * 下拉横幅形成悬浮窗，悬浮窗在中间
   */
  PULL = 0,
  /**
   * 点击横幅拉起悬浮窗，悬浮窗在右侧，需要拉起方自己做过渡动效
   */
  CLICK_WITHOUT_ANIMATION = 1,
  /**
   * 点击横幅拉起悬浮窗，悬浮窗在右侧，自带出场动效
   */
  CLICK_WITH_ANIMATION = 2,
}