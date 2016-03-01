#= require_tree ./templates
#= require_self

$(document).ready ->
  if $('.js-tiers-quantity').length
    calculatorName = $('.js-tiers-quantity').data('calculator')
    tierFieldsTemplate = HandlebarsTemplates["bulk_discounts/calculators/fields/#{calculatorName}"]
    originalTiers = $('.js-tiers-quantity').data('original-tiers')
    formPrefix = $('.js-tiers-quantity').data('form-prefix')

    tierInputName = (base) ->
      "#{formPrefix}[calculator_attributes][preferred_tiers][#{base}]"

    $.each originalTiers, (base, value) ->
      $('.js-tiers-quantity').append tierFieldsTemplate
        baseField:
          value: base
        valueField:
          name: tierInputName(base)
          value: value

    $(document).on 'click', '.js-add-tier', (event) ->
      event.preventDefault()
      $('.js-tiers-quantity').append tierFieldsTemplate(valueField: {name: null})

    $(document).on 'click', '.js-remove-tier', (event) ->
      event.preventDefault()
      $(this).parents('.tier').remove()

    $(document).on 'change', '.js-base-input', (event) ->
      valueInput = $(this).parents('.tier').find('.js-value-input')
      valueInput.attr 'name', tierInputName($(this).val())